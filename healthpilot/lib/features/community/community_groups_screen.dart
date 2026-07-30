import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:healthpilot/core/auth/auth_state.dart';
import 'package:healthpilot/features/chat/group_chat_screen.dart';
import 'package:healthpilot/features/community/community_models.dart';
import 'package:healthpilot/features/community/community_provider.dart';

/// Browse, create, join and leave community support groups
/// (`/community/groups/`). Standalone screen; the list itself is
/// [CommunityGroupsBody] so the Community hub can embed it.
class CommunityGroupsScreen extends StatelessWidget {
  const CommunityGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Groups')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCreateCommunityGroupDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New group'),
      ),
      body: const SafeArea(child: CommunityGroupsBody()),
    );
  }
}

/// The groups list (no Scaffold) — reusable inside the Community hub.
class CommunityGroupsBody extends StatelessWidget {
  const CommunityGroupsBody({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<CommunityProvider>().groups;
    return RefreshIndicator(
      onRefresh: () => context.read<CommunityProvider>().refreshGroups(),
      child: groups.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No groups yet. Create the first one.')),
              ],
            )
          : ListView.separated(
              padding: padding ?? const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: groups.length,
              itemBuilder: (context, i) => CommunityGroupCard(group: groups[i]),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
            ),
    );
  }
}

/// Shows the "new community group" dialog (shared by the standalone screen and
/// the Community hub).
Future<void> showCreateCommunityGroupDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final slugCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var submitting = false;

    String slugify(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'(^-+)|(-+$)'), '');

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('New community group'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (v) {
                    if (slugCtrl.text.isEmpty ||
                        slugCtrl.text == slugify(nameCtrl.text)) {
                      slugCtrl.text = slugify(v);
                    }
                  },
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: slugCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Slug',
                    helperText: 'URL-friendly identifier (e.g. diabetes-support)',
                    helperMaxLines: 2,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: descCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Description (optional)'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: submitting ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: submitting
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      setLocal(() => submitting = true);
                      try {
                        await context.read<CommunityProvider>().createGroup(
                              name: nameCtrl.text.trim(),
                              slug: slugify(slugCtrl.text),
                              description: descCtrl.text.trim(),
                            );
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      } catch (_) {
                        setLocal(() => submitting = false);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Could not create group (slug may be taken).')),
                          );
                        }
                      }
                    },
              child: Text(submitting ? 'Creating…' : 'Create'),
            ),
          ],
        ),
      ),
    );

    // The dialog has been dismissed; dispose its controllers so they don't leak.
    nameCtrl.dispose();
    slugCtrl.dispose();
    descCtrl.dispose();
  }

class CommunityGroupCard extends StatelessWidget {
  const CommunityGroupCard({super.key, required this.group});
  final CommunityGroup group;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: () => _viewGroupDetails(context, group.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(group.name,
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  if (group.isMember)
                    OutlinedButton(
                      onPressed: () => _membership(
                        context,
                        context.read<CommunityProvider>().leaveGroup(group.id),
                        'Could not leave group. Please try again.',
                      ),
                      child: const Text('Leave'),
                    )
                  else
                    FilledButton(
                      onPressed: () => _membership(
                        context,
                        context.read<CommunityProvider>().joinGroup(group.id),
                        'Could not join group. Please try again.',
                      ),
                      child: const Text('Join'),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDeleteGroup(context, group.id),
                    tooltip: 'Delete group',
                  ),
                ],
              ),
            if (group.description != null && group.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(group.description!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.group_outlined, size: 16, color: cs.primary),
                const SizedBox(width: 4),
                Text('${group.memberCount} members',
                    style: Theme.of(context).textTheme.bodySmall),
                if (group.conditionTags.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      group.conditionTags.join(', '),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            // Chat membership is handled by Community join/leave. Use
            // chat_group_id only to open messages (Chat API).
            if (group.isMember && group.chatGroupId != null) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _openChat(context),
                  icon: const Icon(Icons.forum_outlined, size: 18),
                  label: const Text('Open group chat'),
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  /// Shows group details dialog when the card is tapped.
  Future<void> _viewGroupDetails(BuildContext context, int groupId) async {
    try {
      final group = await context.read<CommunityProvider>().fetchGroup(groupId);
      if (!context.mounted) return;
      
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(group.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (group.description != null && group.description!.isNotEmpty) ...[
                Text(group.description!),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  const Icon(Icons.group_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text('${group.memberCount} members'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    group.isMember ? Icons.check_circle : Icons.circle_outlined,
                    size: 16,
                    color: group.isMember ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(group.isMember ? 'You are a member' : 'Not a member'),
                ],
              ),
              if (group.conditionTags.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text('Tags:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: group.conditionTags
                      .map((tag) => Chip(
                            label: Text(tag),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load group details')),
        );
      }
    }
  }

  /// Awaits a join/leave [action] and surfaces a SnackBar on failure (the
  /// provider only applies its optimistic update on success, so there's nothing
  /// to revert — the gap was the silent failure + missing feedback).
  Future<void> _membership(
      BuildContext context, Future<void> action, String errorMsg) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action;
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(errorMsg)));
    }
  }

  /// Opens the linked GroupChat via Chat API. Community join already added the
  /// user to the room — do not call `/chat/groups/{id}/join/`.
  void _openChat(BuildContext context) {
    final chatGroupId = group.chatGroupId;
    if (chatGroupId == null) return;
    final userId = context.read<AuthState>().userId;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => GroupChatScreen(groupId: chatGroupId, userId: userId),
    ));
  }

  /// Shows confirmation dialog and deletes the group if confirmed.
  Future<void> _confirmDeleteGroup(BuildContext context, int groupId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await context.read<CommunityProvider>().deleteGroup(groupId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Group deleted successfully')),
          );
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete group')),
          );
        }
      }
    }
  }
}
