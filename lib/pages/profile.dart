import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:lali/pages/rooms.dart';
import '/blocs/notification_bloc.dart';
import '/blocs/sign_in_bloc.dart';
import '/core/config/config.dart';
import '/pages/edit_profile.dart';
import '/pages/notifications.dart';
import '/pages/sign_in.dart';
import '/core/utils/next_screen.dart';
import '/widgets/language.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  openAboutDialog() {
    final sb = context.read<SignInBloc>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AboutDialog(
            applicationName: Config().appName,
            applicationIcon: Image(
              image: AssetImage(Config().splashIcon),
              height: 30,
              width: 30,
            ),
            applicationVersion: sb.appVersion,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('profile').tr(),
          centerTitle: false,
          actions: [
            IconButton(
                icon: const Icon(Icons.notifications, size: 20),
                onPressed: () {
                  nextScreen(context, const NotificationsPage());
                })
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          children: [
            sb.isSignedIn == false ? const GuestUserUI() : const UserUI(),
            const Text(
              "general setting",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ).tr(),
            const SizedBox(
              height: 15,
            ),
            ListTile(
                title: const Text('get notifications').tr(),
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Icon(Icons.notifications, size: 20, color: Colors.white),
                ),
                trailing: Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: context.watch<NotificationBloc>().subscribed,
                  onChanged: (bool value) {
                    context.read<NotificationBloc>().fcmSubscribe(value);
                    if (value) {
                      openAppSettings();
                    }
                  },
                )),
            const Divider(
              height: 5,
            ),
            ListTile(
              title: const Text('contact us').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.mail, size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
              onTap: () async {
                if (await canLaunchUrlString(
                    "https://github.com/alaminXpro/lali/blob/main/README.md")) {
                  launchUrlString("https://github.com/alaminXpro/lali/blob/main/README.md");
                }
              },
            ),
            const Divider(
              height: 5,
            ),
            ListTile(
              title: const Text('language').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.circle, size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
              onTap: () => nextScreenPopup(context, const LanguagePopup()),
            ),
            const Divider(
              height: 5,
            ),
            ListTile(
              title: const Text('rate this app').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.star, size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
              onTap: () async {},
            ),
            const Divider(
              height: 5,
            ),
            ListTile(
              title: const Text('licence').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.panorama_photosphere,
                    size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
              onTap: () => openAboutDialog(),
            ),
            const Divider(
              height: 5,
            ),
            ListTile(
              title: const Text('privacy policy').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.lock, size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
              onTap: () async {
                // if (await canLaunchUrl(Config().privacyPolicyUrl as Uri)) {
                //   launchUrl(Config().privacyPolicyUrl as Uri);
                // }
              },
            ),
            const Divider(
              height: 5,
            ),
            // Removed About Us entry
            ListTile(
              title: const Text('Admin').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.source, size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
              onTap: () async {
                if (await canLaunchUrlString(
                    "https://www.linkedin.com/in/alaminxpro/")) {
                  launchUrlString("https://www.linkedin.com/in/alaminxpro/");
                }
              },
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class GuestUserUI extends StatelessWidget {
  const GuestUserUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('login').tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)),
            child: const Icon(Icons.person, size: 20, color: Colors.white),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 20,
          ),
          onTap: () => nextScreenPopup(
              context,
              const SignInPage(
                tag: 'popup',
              )),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  const UserUI({super.key});

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Column(
            children: [
              CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: CachedNetworkImageProvider(sb.imageUrl)),
              const SizedBox(
                height: 10,
              ),
              Text(
                sb.name,
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        ListTile(
          title: Text(sb.email),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)),
            child: const Icon(Icons.mail, size: 20, color: Colors.white),
          ),
        ),
        const Divider(
          height: 5,
        ),
        ListTile(
          title: Text(sb.joiningDate),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(5)),
            child: const Icon(LineIcons.home, size: 20, color: Colors.white),
          ),
        ),
        const Divider(
          height: 5,
        ),
        ListTile(
            title: const Text('edit profile').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: const Icon(Icons.edit, size: 20, color: Colors.white),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              size: 20,
            ),
            onTap: () {
              nextScreen(
                  context, EditProfile(name: sb.name, imageUrl: sb.imageUrl));
            }),
        const Divider(
          height: 5,
        ),
        ListTile(
            title: const Text('Chat Room').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              child: const Icon(Icons.chat, size: 20, color: Colors.white),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              size: 20,
            ),
            onTap: () {
              nextScreen(context, const RoomsPage());
            }),
        const Divider(
          height: 5,
        ),
        ListTile(
          title: const Text('logout').tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)),
            child: const Icon(Icons.logout, size: 20, color: Colors.white),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 20,
          ),
          onTap: () => openLogoutDialog(context),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }

  void openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('logout title').tr(),
            actions: [
              TextButton(
                child: const Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('yes').tr(),
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<SignInBloc>().userSignout();
                  if (!context.mounted) return;
                  nextScreenCloseOthers(context, const SignInPage(tag: ''));
                },
              )
            ],
          );
        });
  }
}
