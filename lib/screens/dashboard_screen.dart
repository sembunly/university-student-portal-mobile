import 'package:flutter/cupertino.dart';

import '../services/auth_store.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.authStore});

  final AuthStore authStore;

  @override
  Widget build(BuildContext context) {
    final account = authStore.account!;
    final profile = authStore.profile;

    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Dashboard'),
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: UspMark(),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(38, 38),
              onPressed: () => _confirmLogout(context),
              child: const Icon(CupertinoIcons.square_arrow_right, size: 22),
            ),
            border: null,
            backgroundColor: AppColors.background.withValues(alpha: 0.9),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
            sliver: SliverList.list(
              children: [
                _WelcomeCard(
                  name: profile?.nameEn ?? profile?.nameKm,
                  studentId: account.studentId ?? 'Pending',
                  phone: account.phone,
                ),
                const SizedBox(height: 20),
                if (!account.profileCompleted) ...[
                  _ProfilePrompt(onPressed: () => _openProfile(context)),
                  const SizedBox(height: 20),
                ],
                const _SectionLabel('QUICK ACCESS'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _QuickTile(
                        icon: CupertinoIcons.person_crop_circle,
                        title: 'Profile',
                        subtitle: 'Student info',
                        tint: AppColors.blue,
                        onPressed: () => _openProfile(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickTile(
                        icon: CupertinoIcons.book,
                        title: 'Curriculum',
                        subtitle: 'Your courses',
                        tint: AppColors.success,
                        onPressed: () => Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (_) => const _CurriculumScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionLabel('LATEST'),
                const SizedBox(height: 10),
                const _NoticeCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You will need your phone or student ID and password to sign in again.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) await authStore.logout();
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => ProfileScreen(authStore: authStore),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.name,
    required this.studentId,
    required this.phone,
  });

  final String? name;
  final String studentId;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final displayName = name?.trim();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF214FC6), Color(0xFF12358D)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x382457D6),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -18,
            top: -28,
            child: Icon(
              CupertinoIcons.book_fill,
              color: Color(0x18FFFFFF),
              size: 145,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WELCOME BACK',
                style: TextStyle(
                  color: Color(0xBFFFFFFF),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                displayName?.isNotEmpty == true
                    ? displayName!
                    : 'Your student space',
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  _CardDetail(label: 'STUDENT ID', value: studentId),
                  Container(
                    height: 32,
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: const Color(0x33FFFFFF),
                  ),
                  _CardDetail(label: 'PHONE', value: phone),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardDetail extends StatelessWidget {
  const _CardDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0x99FFFFFF),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProfilePrompt extends StatelessWidget {
  const _ProfilePrompt({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF1FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD5E2FF)),
        ),
        child: const Row(
          children: [
            Icon(
              CupertinoIcons.person_crop_circle_badge_exclam,
              color: AppColors.blue,
            ),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile setup is next',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to enter your information and receive your student ID.',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_forward,
              color: AppColors.blue,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tint,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color tint;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      pressedOpacity: 0.72,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: tint, size: 21),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.secondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurriculumScreen extends StatelessWidget {
  const _CurriculumScreen();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Curriculum'),
        backgroundColor: Color(0xF2F7F8FC),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    CupertinoIcons.book,
                    color: AppColors.success,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your curriculum',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your courses will appear here when curriculum data is available.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.bell_fill, color: AppColors.blue, size: 20),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to USP Student',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                SizedBox(height: 6),
                Text(
                  'Your announcements and academic updates will appear here.',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'TODAY',
            style: TextStyle(
              color: Color(0xFF9BA2B2),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
        color: AppColors.secondary,
      ),
    );
  }
}
