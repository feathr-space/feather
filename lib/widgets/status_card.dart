import 'package:feathr/services/api.dart';
import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:feathr/data/status.dart';

/// The [StatusCard] widget wraps and displays information for a given
/// [Status] instance.
class StatusCard extends StatefulWidget {
  /// Main instance of the API service to use in the widget.
  final ApiService apiService;

  /// The [Status] instance that will be displayed with this widget (initially).
  final Status initialStatus;

  const StatusCard(
    this.initialStatus, {
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  /// The [Status] instance that will be displayed with this widget.
  late Status status;

  @override
  void initState() {
    status = widget.initialStatus;
    super.initState();
  }

  /// Makes a call unto the Mastodon API in order to (un)favorite the current
  /// toot, and updates the toot's state in the current widget accordingly.
  Future<void> onFavoritePress() async {
    Status newStatus;

    // TODO: handle error cases
    if (status.favorited) {
      newStatus = await widget.apiService.undoFavoriteStatus(status.id);
    } else {
      newStatus = await widget.apiService.favoriteStatus(status.id);
    }

    setState(() {
      status = newStatus;
    });
  }

  /// Makes a call unto the Mastodon API in order to (un)bookmark the current
  /// toot, and updates the toot's state in the current widget accordingly.
  Future<void> onBookmarkPress() async {
    Status newStatus;

    // TODO: handle error cases
    if (status.bookmarked) {
      newStatus = await widget.apiService.undoBookmarkStatus(status.id);
    } else {
      newStatus = await widget.apiService.bookmarkStatus(status.id);
    }

    setState(() {
      status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: display more information on each status
    // TODO: main text color (Colors.white) should change depending on theme
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              foregroundImage: status.account.avatarUrl != null
                  ? NetworkImage(status.account.avatarUrl!)
                  : null,
            ),
            title: Text(
              status.account.displayName != ""
                  ? status.account.displayName
                  : status.account.username,
            ),
            subtitle: Text(
              status.account.acct,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Html(
              data: status.content,
              style: {
                'p': Style(
                  color: Colors.white.withOpacity(0.6),
                )
              },
              // TODO: handle @mentions and #hashtags differently
              onLinkTap: (url, renderContext, attributes, element) => {
                if (url != null) {launch(url)}
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                // TODO: boost action
                onPressed: () {},
                tooltip: "Boost",
                icon: const Icon(FeatherIcons.repeat),
                color: status.reblogged ? Colors.green : null,
              ),
              IconButton(
                onPressed: onFavoritePress,
                tooltip: "Favorite",
                icon: const Icon(FeatherIcons.star),
                color: status.favorited ? Colors.yellow : null,
              ),
              IconButton(
                onPressed: onBookmarkPress,
                tooltip: "Bookmark",
                icon: const Icon(FeatherIcons.bookmark),
                color: status.bookmarked ? Colors.blue : null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
