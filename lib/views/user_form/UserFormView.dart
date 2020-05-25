import 'package:crudsample/models/UserModel.dart';
import 'package:crudsample/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFormView extends StatefulWidget {
  @override
  _UserFormViewState createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final _form = GlobalKey<FormState>();

  final Map<String, Object> _formData = {};

  void _loadFormData(UserModel user) {
    if(user == null) return;
    
    this._formData['id'] = user.id;
    this._formData['name'] = user.name;
    this._formData['email'] = user.email;
    this._formData['avatarUrl'] = user.avatarUrl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final UserModel user = ModalRoute.of(context).settings.arguments;
    this._loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuário'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (this._form.currentState.validate()) {
                this._form.currentState.save();

                Provider.of<UserProvider>(context, listen: false).put(
                  UserModel(
                    id: this._formData['id'],
                    name: this._formData['name'],
                    email: this._formData['email'],
                    avatarUrl: this._formData['avatarUrl'],
                  ),
                );

                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
            key: this._form,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  initialValue: this._formData['name'],
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Nome não pode ser vazio';

                    if (value.trim().length < 3)
                      return 'Nome deve conter mais do que 3 caracteres.';

                    return null;
                  },
                  onSaved: (value) => this._formData['name'] = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  initialValue: this._formData['email'],
                  onSaved: (value) => this._formData['email'] = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Url do Avatar'),
                  initialValue: this._formData['avatarUrl'],
                  onSaved: (value) => this._formData['avatarUrl'] = value,
                )
              ],
            )),
      ),
    );
  }
}
