import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../services/api_url_store.dart';
import '../services/bot_api_service.dart';
import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';
import '../widgets/glow_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.urlStore,
    required this.api,
    required this.onUrlSaved,
  });

  final ApiUrlStore urlStore;
  final BotApiService api;
  final VoidCallback onUrlSaved;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _controller;
  bool _testing = false;
  String? _testResult;
  bool? _testOk;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.urlStore.baseUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await widget.urlStore.save(_controller.text);
    widget.onUrlSaved();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sačuvano: ${widget.urlStore.baseUrl}'),
        backgroundColor: AppColors.card,
      ),
    );
  }

  Future<void> _test() async {
    setState(() {
      _testing = true;
      _testResult = null;
      _testOk = null;
    });
    try {
      await widget.urlStore.save(_controller.text);
      final ok = await widget.api.checkHealth();
      if (!mounted) return;
      setState(() {
        _testOk = ok;
        _testResult = ok
            ? 'Konekcija OK — bot API dostupan.'
            : 'API odgovara, ali bot_state još nije spreman.';
      });
      if (ok) widget.onUrlSaved();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _testOk = false;
        _testResult = '$error';
      });
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  void _applyPreset(String url) {
    _controller.text = url;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PODEŠAVANJA',
            style: NeonStyles.neonText(
              AppColors.neonBlue,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              blur: 8,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Unesi adresu bota. Radi sa LAN IP, Tailscale (100.x.x.x) ili ngrok/Cloudflare HTTPS — bez rebuild-a aplikacije.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11, height: 1.4),
          ),
          const SizedBox(height: 16),
          GlowCard(
            glowColor: AppColors.neonBlue,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'API SERVER URL',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.text, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'http://100.x.x.x:5000',
                    hintStyle: TextStyle(color: AppColors.textDim.withOpacity(0.7)),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.neonBlue.withOpacity(0.35)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.neonBlue.withOpacity(0.7)),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'SAČUVAJ',
                        color: AppColors.neonBlue,
                        onTap: _save,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        label: _testing ? 'TEST...' : 'TEST',
                        color: AppColors.neonGreen,
                        onTap: _testing ? null : _test,
                      ),
                    ),
                  ],
                ),
                if (_testResult != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _testResult!,
                    style: TextStyle(
                      color: _testOk == true ? AppColors.neonGreen : AppColors.neonRed,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'BRZI PRESETI (pritisni pa Sačuvaj / Test)',
            style: TextStyle(color: AppColors.textDim, fontSize: 10, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          _PresetChip(
            label: 'LAN server',
            value: ApiConfig.defaultBaseUrl,
            onTap: () => _applyPreset(ApiConfig.defaultBaseUrl),
          ),
          const SizedBox(height: 6),
          _PresetChip(
            label: 'Tailscale primer',
            value: 'http://100.x.x.x:5000',
            onTap: () => _applyPreset('http://100.x.x.x:5000'),
          ),
          const SizedBox(height: 6),
          _PresetChip(
            label: 'Ngrok / Cloudflare primer',
            value: 'https://tvoj-tunnel.ngrok-free.app',
            onTap: () => _applyPreset('https://tvoj-tunnel.ngrok-free.app'),
          ),
          const SizedBox(height: 16),
          Text(
            'Aktivni URL: ${widget.urlStore.baseUrl}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: NeonStyles.neonButton(color),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: AppColors.text, fontSize: 11, fontWeight: FontWeight.w600)),
                  Text(value, style: const TextStyle(color: AppColors.textDim, fontSize: 10)),
                ],
              ),
            ),
            Icon(Icons.edit_outlined, size: 14, color: AppColors.textDim.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }
}
