import 'package:flutter/material.dart';
import 'package:healthpilot/features/health_assessment/allergy_suggestion_catalog.dart';
import 'package:healthpilot/features/health_assessment/health_assessment_models.dart';
import 'package:healthpilot/features/health_assessment/health_assessment_subject.dart';
import 'package:healthpilot/features/health_assessment/summary_screen.dart';
import 'package:healthpilot/theme/app_theme.dart';

class HealthAssessmentFlowScreen extends StatefulWidget {
  const HealthAssessmentFlowScreen({super.key});

  @override
  State<HealthAssessmentFlowScreen> createState() =>
      _HealthAssessmentFlowScreenState();
}

class _HealthAssessmentFlowScreenState
    extends State<HealthAssessmentFlowScreen> {
  final _pageController = PageController();

  int _page = 0;
  static const int _otherSymptomsPageIndex = 5;
  static const int _addMoreSymptomsPageIndex = 6;
  static const int _trendPageIndex = 7;
  HealthAssessmentSubject? _subject;
  BloodType? _bloodType;
  final _allergiesController = TextEditingController();

  // The search box starts empty (full catalog visible); 'Cough' stays as a
  // preselected chip so the step's "continue" gate is satisfied by default.
  final _symptomController = TextEditingController();
  final Set<String> _selectedSymptoms = {'Cough'};

  String?
      _symptomDuration; // Less than a week | More than a week | More than a month
  bool? _hasOtherSymptoms; // Yes/No
  String? _symptomsTrend; // worse/better/no_change

  @override
  void initState() {
    super.initState();
    _allergiesController.addListener(_onAllergiesChanged);
  }

  void _onAllergiesChanged() {
    // Only affects CTA label/enabled state on the allergies step.
    if (!mounted) return;
    if (_page == 2) setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _allergiesController.removeListener(_onAllergiesChanged);
    _allergiesController.dispose();
    _symptomController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_page) {
      case 0:
        return _subject != null;
      case 1:
        return _bloodType != null;
      case 2:
        // Allergies can be skipped.
        return true;
      case 3:
        return _selectedSymptoms.isNotEmpty;
      case 4:
        return _symptomDuration != null;
      case _otherSymptomsPageIndex:
        return _hasOtherSymptoms != null;
      case _addMoreSymptomsPageIndex:
        // User already had some symptoms; but if they deleted all, block.
        return _selectedSymptoms.isNotEmpty;
      case _trendPageIndex:
        return _symptomsTrend != null;
      default:
        return true;
    }
  }

  String get _ctaLabel {
    if (_page == _trendPageIndex) return 'Finish';
    // Allergies step: show Skip only when empty.
    if (_page == 2) {
      return _allergiesController.text.trim().isEmpty ? 'Skip' : 'Next';
    }
    return 'Next';
  }

  void _goNext() {
    if (_page == _otherSymptomsPageIndex && _hasOtherSymptoms == false) {
      _pageController.animateToPage(
        _trendPageIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      return;
    }

    if (_page < _trendPageIndex) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SummaryScreen(
          subject: _subject,
          bloodType: _bloodType,
          allergies: _allergiesController.text.trim(),
          symptoms: _selectedSymptoms.toList()..sort(),
          symptomDuration: _symptomDuration,
          hasOtherSymptoms: _hasOtherSymptoms,
          symptomsTrend: _symptomsTrend,
        ),
      ),
    );
  }

  void _goBack() {
    if (_page == 0) return;
    if (_page == _trendPageIndex && _hasOtherSymptoms == false) {
      _pageController.animateToPage(
        _otherSymptomsPageIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      return;
    }
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  /// Clears every answer and returns to the first step (after confirmation).
  Future<void> _resetFlow() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Start over?'),
        content: const Text(
            'This clears your answers and returns to the first step.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Start over'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() {
      _subject = null;
      _bloodType = null;
      _allergiesController.clear();
      _symptomController.clear();
      _selectedSymptoms
        ..clear()
        ..add('Cough');
      _symptomDuration = null;
      _hasOtherSymptoms = null;
      _symptomsTrend = null;
      _page = 0;
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: 'Health Assessment',
              onBack: () {
                if (_page == 0) {
                  Navigator.maybePop(context);
                } else {
                  _goBack();
                }
              },
              onReset: _resetFlow,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) => setState(() => _page = idx),
                children: [
                  _WhoForPage(
                    value: _subject,
                    onChanged: (v) {
                      setState(() {
                        if (_subject != v) {
                          _bloodType = null;
                        }
                        _subject = v;
                      });
                    },
                  ),
                  _BloodTypePage(
                    value: _bloodType,
                    subject: _subject,
                    onChanged: (v) => setState(() => _bloodType = v),
                  ),
                  _AllergiesPage(controller: _allergiesController),
                  _SymptomsPage(
                    title: 'Add your symptoms',
                    controller: _symptomController,
                    selected: _selectedSymptoms,
                    onToggle: (s) {
                      setState(() {
                        if (_selectedSymptoms.contains(s)) {
                          _selectedSymptoms.remove(s);
                        } else {
                          _selectedSymptoms.add(s);
                        }
                      });
                    },
                  ),
                  _DurationPage(
                    value: _symptomDuration,
                    onChanged: (v) => setState(() => _symptomDuration = v),
                  ),
                  _OtherSymptomsPage(
                    value: _hasOtherSymptoms,
                    onChanged: (v) => setState(() => _hasOtherSymptoms = v),
                  ),
                  _SymptomsPage(
                    title: 'Add other symptoms',
                    controller: _symptomController,
                    selected: _selectedSymptoms,
                    onToggle: (s) {
                      setState(() {
                        if (_selectedSymptoms.contains(s)) {
                          _selectedSymptoms.remove(s);
                        } else {
                          _selectedSymptoms.add(s);
                        }
                      });
                    },
                  ),
                  _TrendPage(
                    value: _symptomsTrend,
                    onChanged: (v) => setState(() => _symptomsTrend = v),
                  ),
                ],
              ),
            ),
            const _BottomInfoLinks(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton(
                  onPressed: _canProceed ? _goNext : null,
                  child: Text(_ctaLabel),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onBack,
    this.onReset,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 12, 10),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              style: AppTheme.circleBackButtonStyle(context),
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.165,
                  ),
            ),
          ),
          IconButton(
            onPressed: onReset,
            icon: const Icon(Icons.refresh),
            tooltip: 'Start over',
          ),
        ],
      ),
    );
  }
}

class _WhoForPage extends StatelessWidget {
  const _WhoForPage({required this.value, required this.onChanged});

  final HealthAssessmentSubject? value;
  final ValueChanged<HealthAssessmentSubject> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text('Who is the assessment for?',
              style: t.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: -0.165,
                color: c.onSurface,
              )),
          const SizedBox(height: 18),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _OutlinedChoice(
                    label: 'Myself',
                    selected: value == HealthAssessmentSubject.myself,
                    onTap: () => onChanged(HealthAssessmentSubject.myself),
                  ),
                  const SizedBox(height: 12),
                  _OutlinedChoice(
                    label: 'Someone else',
                    selected: value == HealthAssessmentSubject.someoneElse,
                    onTap: () => onChanged(HealthAssessmentSubject.someoneElse),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BloodTypePage extends StatelessWidget {
  const _BloodTypePage({
    required this.value,
    required this.onChanged,
    required this.subject,
  });

  final BloodType? value;
  final ValueChanged<BloodType> onChanged;
  final HealthAssessmentSubject? subject;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget option(String label, BloodType v) {
      return _OutlinedChoice(
        label: label,
        selected: value == v,
        onTap: () => onChanged(v),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text(
            subject == HealthAssessmentSubject.myself
                ? 'What is your blood type?'
                : 'What is their blood type?',
            style: t.bodyLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: c.onSurface,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  option('Type A', BloodType.a),
                  const SizedBox(height: 10),
                  option('Type B', BloodType.b),
                  const SizedBox(height: 10),
                  option('Type AB', BloodType.ab),
                  const SizedBox(height: 10),
                  option('Type O', BloodType.o),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllergiesPage extends StatefulWidget {
  const _AllergiesPage({required this.controller});

  final TextEditingController controller;

  @override
  State<_AllergiesPage> createState() => _AllergiesPageState();
}

class _AllergiesPageState extends State<_AllergiesPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant _AllergiesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _appendSuggestion(String name) {
    final c = widget.controller;
    final t = c.text.trim();
    if (t.isEmpty) {
      c.text = name;
    } else if (!t.toLowerCase().contains(name.toLowerCase())) {
      c.text = '$t, $name';
    }
    c.selection = TextSelection.collapsed(offset: c.text.length);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final suggestions =
        AllergySuggestionCatalog.matching(widget.controller.text);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text(
            'Add any known allergies',
            style: t.bodyLarge
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: widget.controller,
            decoration: const InputDecoration(
              hintText: 'Type here...',
              filled: true,
            ),
          ),
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Suggestions',
              style: t.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (ctx, i) {
                  final s = suggestions[i];
                  return Material(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: scheme.outline),
                      ),
                      title:
                          Text(s, style: t.bodyMedium?.copyWith(fontSize: 13)),
                      trailing:
                          Icon(Icons.add, color: scheme.primary, size: 20),
                      onTap: () => _appendSuggestion(s),
                    ),
                  );
                },
              ),
            ),
          ] else
            const Spacer(),
        ],
      ),
    );
  }
}

class _SymptomsPage extends StatefulWidget {
  const _SymptomsPage({
    required this.title,
    required this.controller,
    required this.selected,
    required this.onToggle,
  });

  final String title;
  final TextEditingController controller;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  State<_SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<_SymptomsPage> {
  /// Common symptoms the search box filters against. Anything not here can
  /// still be added as free text via the "Add …" row / keyboard submit.
  static const List<(String, String)> _catalog = [
    ('Cough', 'Dry or wet cough'),
    ('Headache', 'Persistent headache'),
    ('Fever', 'High temperature'),
    ('Sore Throat', 'Pain or scratchiness in the throat'),
    ('Fatigue', 'Unusual tiredness or low energy'),
    ('Shortness of Breath', 'Difficulty breathing'),
    ('Nausea', 'Feeling sick to your stomach'),
    ('Dizziness', 'Lightheadedness or vertigo'),
    ('Muscle Aches', 'Body or muscle pain'),
    ('Runny Nose', 'Nasal congestion or discharge'),
    ('Chills', 'Feeling cold or shivering'),
    ('Diarrhea', 'Loose or frequent stools'),
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onQueryChanged);
    super.dispose();
  }

  void _onQueryChanged() {
    if (mounted) setState(() {});
  }

  /// Adds whatever the user typed as a symptom, then clears the field.
  void _addTyped() {
    final text = widget.controller.text.trim();
    if (text.isEmpty) return;
    if (!widget.selected.any((s) => s.toLowerCase() == text.toLowerCase())) {
      widget.onToggle(text);
    }
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    final query = widget.controller.text.trim();
    final lower = query.toLowerCase();
    final matches = query.isEmpty
        ? _catalog
        : _catalog.where((s) => s.$1.toLowerCase().contains(lower)).toList();
    // Offer a free-text add when the query matches neither the catalog nor an
    // already-selected symptom.
    final canAddCustom = query.isNotEmpty &&
        !_catalog.any((s) => s.$1.toLowerCase() == lower) &&
        !widget.selected.any((s) => s.toLowerCase() == lower);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text(widget.title,
              style: t.bodyLarge
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: 12),
          TextField(
            controller: widget.controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _addTyped(),
            decoration: const InputDecoration(
              hintText: 'Search or type a symptom',
              filled: true,
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 10),
          if (widget.selected.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selected
                  .map((s) => InputChip(
                        label: Text(s),
                        selected: true,
                        onDeleted: () => widget.onToggle(s),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                if (canAddCustom)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: c.primary),
                        borderRadius: BorderRadius.circular(10),
                        color: c.surface,
                      ),
                      child: ListTile(
                        title: Text('Add “$query”',
                            style: t.bodyLarge?.copyWith(fontSize: 13)),
                        subtitle: Text('Use your own words',
                            style: t.bodySmall?.copyWith(fontSize: 11)),
                        trailing:
                            Icon(Icons.add_circle_outline, color: c.primary),
                        onTap: _addTyped,
                      ),
                    ),
                  ),
                if (matches.isEmpty && !canAddCustom)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Center(
                      child: Text('No matching symptoms',
                          style: t.bodySmall
                              ?.copyWith(color: c.onSurfaceVariant)),
                    ),
                  ),
                for (final (title, subtitle) in matches)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: c.outline),
                        borderRadius: BorderRadius.circular(10),
                        color: c.surface,
                      ),
                      child: ListTile(
                        title: Text(title,
                            style: t.bodyLarge?.copyWith(fontSize: 13)),
                        subtitle: Text(subtitle,
                            style: t.bodySmall?.copyWith(fontSize: 11)),
                        trailing: IconButton(
                          onPressed: () => widget.onToggle(title),
                          icon: Icon(
                            widget.selected.contains(title)
                                ? Icons.check_circle
                                : Icons.add_circle_outline,
                            color: c.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationPage extends StatelessWidget {
  const _DurationPage({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text('How long have you had this symptom?',
              style: t.bodyLarge
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: 18),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _OutlinedChoice(
                    label: 'Less than a week',
                    selected: value == 'Less than a week',
                    onTap: () => onChanged('Less than a week'),
                  ),
                  const SizedBox(height: 10),
                  _OutlinedChoice(
                    label: 'More than a week',
                    selected: value == 'More than a week',
                    onTap: () => onChanged('More than a week'),
                  ),
                  const SizedBox(height: 10),
                  _OutlinedChoice(
                    label: 'More than a month',
                    selected: value == 'More than a month',
                    onTap: () => onChanged('More than a month'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherSymptomsPage extends StatelessWidget {
  const _OtherSymptomsPage({required this.value, required this.onChanged});

  final bool? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text('Do you have any other symptoms?',
              style: t.bodyLarge
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: 18),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _OutlinedChoice(
                    label: 'No, I don’t',
                    selected: value == false,
                    onTap: () => onChanged(false),
                  ),
                  const SizedBox(height: 10),
                  _OutlinedChoice(
                    label: 'Yes, I do',
                    selected: value == true,
                    onTap: () => onChanged(true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPage extends StatelessWidget {
  const _TrendPage({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text(
            'Okay, final question. How are your symptoms changing overtime?',
            style: t.bodyLarge
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _OutlinedChoice(
                    label: 'They’re getting worse',
                    selected: value == 'worse',
                    onTap: () => onChanged('worse'),
                  ),
                  const SizedBox(height: 10),
                  _OutlinedChoice(
                    label: 'They’re getting better',
                    selected: value == 'better',
                    onTap: () => onChanged('better'),
                  ),
                  const SizedBox(height: 10),
                  _OutlinedChoice(
                    label: 'There is no change',
                    selected: value == 'no_change',
                    onTap: () => onChanged('no_change'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlinedChoice extends StatelessWidget {
  const _OutlinedChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return SizedBox(
      width: 180,
      height: 36,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: selected ? c.primary : c.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          foregroundColor: c.onSurface,
          backgroundColor: selected ? c.primaryContainer : null,
          textStyle:
              t.bodyMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}

class _BottomInfoLinks extends StatelessWidget {
  const _BottomInfoLinks();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget row(String label, String sheetTitle, String sheetBody) {
      return InkWell(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) {
              final size = MediaQuery.of(context).size;
              return SizedBox(
                width: double.infinity,
                height: size.height * 0.58,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sheetTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            sheetBody,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: t.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: c.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            row(
              'Don’t understand? Here is a description',
              'About this assessment',
              'This quick check collects a few basics — who it’s for, blood type, '
                  'and any allergies — along with your current symptoms, then gives '
                  'general, non-diagnostic guidance. Answer what you can; optional '
                  'steps like allergies can be skipped. It takes about a minute.',
            ),
            row(
              'Why am I being asked this',
              'Why we ask',
              'Each question helps tailor your result. Blood type and allergies flag '
                  'safety considerations, and symptom details — how long you’ve had '
                  'them and whether they’re changing — help gauge urgency. Your '
                  'answers are used only to generate this assessment and are not a '
                  'substitute for professional medical advice.',
            ),
          ],
        ),
      ),
    );
  }
}
