import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/cubit/add_note_cubit.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/cubit/fetch_note_cubit.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/widgets/custom_field_button.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class CreateNotesScreen extends StatefulWidget {
  final Todo? todo;
  const CreateNotesScreen({
    super.key,
    this.todo,
  });

  @override
  State<CreateNotesScreen> createState() => _CreateNotesScreenState();
}

class _CreateNotesScreenState extends State<CreateNotesScreen> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey();
  // Future<void> onSave() async {
  //   try {
  //     context.loaderOverlay.show();
  //     final dio = Dio();
  //     final res = await dio.post(
  //         "https://note-backend-n9u1.onrender.com/api/notes",
  //         data: _formKey.currentState!.value);
  //     Fluttertoast.showToast(msg: "Notes saved successfully");
  //     Navigator.of(context).pop(true);
  //   } on DioException catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.response?.data["message"] ?? "Unable to save note");
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "unable to save message");
  //   } finally {
  //     context.loaderOverlay.hide();
  //   }
  // }

  Future<void> onUpdate() async {
    try {
      context.loaderOverlay.show();
      final dio = Dio();
      final _ = await dio.put(
          "https://note-backend-n9u1.onrender.com/api/notes/${widget.todo?.id}",
          data: _formKey.currentState!.value);
      Fluttertoast.showToast(msg: "Notes Updated successfully");
      Navigator.of(context).pop(true);
    } on DioException catch (e) {
      Fluttertoast.showToast(
          msg: e.response?.data["message"] ?? "Unable to Update note");
    } catch (e) {
      Fluttertoast.showToast(msg: "unable to Update message");
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _formKey.currentState!.reset();
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: BlocListener<AddNoteCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoadingState) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }

          if (state is CommonSuccessState) {
            Fluttertoast.showToast(msg: "Note added successfully.");
            context.read<FetchNoteCubit>().fetch();
            Navigator.of(context).pop();
          } else if (state is CommonErrorState) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  label: "Title",
                  hintText: "Enter title",
                  name: "title",
                  initialValue: widget.todo?.title,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Title cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                CustomTextField(
                  label: "Description",
                  hintText: "Enter Description",
                  name: "description",
                  initialValue: widget.todo?.description,
                  maxLine: 4,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Description cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                CustomFilledButton(
                  label: widget.todo != null ? "Update" : "Save",
                  onPressed: () async {
                    if (_formKey.currentState!.saveAndValidate()) {
                      if (widget.todo != null) {
                        onUpdate();
                      } else {
                        context.read<AddNoteCubit>().addNote(
                              title: _formKey.currentState!.value["title"],
                              description:
                                  _formKey.currentState!.value["description"],
                            );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
