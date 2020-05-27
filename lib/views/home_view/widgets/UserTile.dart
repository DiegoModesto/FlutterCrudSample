import 'package:crudsample/models/UserModel.dart';
import 'package:crudsample/provider/UserProvider.dart';
import 'package:crudsample/routes/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatefulWidget {
  final UserModel user;

  const UserTile(this.user);

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final avatar = widget.user.avatarUrl == null ||
            widget.user.avatarUrl.trim().isEmpty
        ? CircleAvatar(child: Icon(Icons.person))
        : CircleAvatar(backgroundImage: NetworkImage(widget.user.avatarUrl));

    return ListTile(
      leading: avatar,
      title: Text(widget.user.name),
      subtitle: Text(widget.user.email),
      trailing: Container(
        width: 100,
        child: _isLoading
            ? Row(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.USER_FORM);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Remoção de usuário'),
                          content: Text(
                              'Deseja realmente remover o usuário${widget.user.name}'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Não'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            FlatButton(
                              child: Text('Sim'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                      ).then((confirmed) async {
                        if (confirmed) {
                          setState(() {
                            _isLoading = true;
                          });

                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .delete(widget.user);

                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
