import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/app_session.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';

// ─── MODELS ──────────────────────────────────────────────────────────────────
class _Contact {
  final int id;
  final String name;
  final String initials;
  final String role;
  final String lastMessage;
  final bool online;
  final Color avatarColor;
  final String badge;

  const _Contact({
    required this.id,
    required this.name,
    required this.initials,
    required this.role,
    required this.lastMessage,
    required this.online,
    required this.avatarColor,
    this.badge = '',
  });
}

class _Message {
  final String text;
  final String time;
  final bool isMe;
  final bool isDeleted;
  final bool isReported;

  const _Message({
    required this.text,
    required this.time,
    required this.isMe,
    this.isDeleted = false,
    this.isReported = false,
  });

  _Message copyWith({bool? isDeleted, bool? isReported}) => _Message(
        text: text,
        time: time,
        isMe: isMe,
        isDeleted: isDeleted ?? this.isDeleted,
        isReported: isReported ?? this.isReported,
      );
}

class _Suggestion {
  final String name;
  final String type;
  final String description;
  final Color iconBg;
  final Color iconColor;
  final Color btnColor;
  final String btnLabel;
  final IconData icon;

  const _Suggestion({
    required this.name,
    required this.type,
    required this.description,
    required this.iconBg,
    required this.iconColor,
    required this.btnColor,
    required this.btnLabel,
    required this.icon,
  });
}

// ─── MOCK DATA ────────────────────────────────────────────────────────────────
const _kContacts = [
  _Contact(id: 1, name: 'Joao Silva', initials: 'JS', role: 'Desenvolvedor Full Stack', lastMessage: 'Ótimo! Podemos marcar uma reuniao?', online: true, avatarColor: Color(0xFF5C6BC0), badge: 'Aluno'),
  _Contact(id: 2, name: 'Maria Santos', initials: 'MS', role: 'Recrutadora - Tech Corp', lastMessage: 'Vi seu projeto de IoT, muito interessante!', online: true, avatarColor: Color(0xFF8E24AA), badge: 'Recrutador'),
  _Contact(id: 3, name: 'Pedro Costa', initials: 'PC', role: 'Engenheiro de Software', lastMessage: 'Obrigado pela ajuda no código!', online: false, avatarColor: Color(0xFF00838F), badge: 'Empresa'),
  _Contact(id: 4, name: 'Ana Lima', initials: 'AL', role: 'Designer UX/UI', lastMessage: 'Adorei seu prototipo!', online: true, avatarColor: Color(0xFFE53935), badge: 'Aluno'),
];

final _kMessages = {
  1: [
    const _Message(text: 'Oi! Vi seu perfil no SENAC DevNest. Seu projeto de automacao e incrivel!', time: '10:10', isMe: false),
    const _Message(text: 'Que legal, obrigado! Trabalhei muito nele.', time: '10:12', isMe: true),
    const _Message(text: 'Ótimo! Podemos marcar uma reuniao?', time: '10:15', isMe: false),
    const _Message(text: 'Claro, quando voce preferir!', time: '10:17', isMe: true),
  ],
  2: [
    const _Message(text: 'Ola! Vi seu projeto de Sistema de Automacao Residencial no Observatório PI.', time: '10:30', isMe: false),
    const _Message(text: 'Ola Maria! Obrigado pelo interesse. Como posso ajudar?', time: '10:32', isMe: true),
    const _Message(text: 'Trabalho na Tech Corp e estamos procurando desenvolvedores com experiencia em IoT.', time: '10:35', isMe: false),
    const _Message(text: 'Sim, tenho muito interesse! Pode me contar mais sobre a vaga?', time: '10:37', isMe: true),
    const _Message(text: 'Claro! E uma posição de desenvolvedor junior focada em solucoes IoT.', time: '10:40', isMe: false),
    const _Message(text: 'Clique nesse link suspeito agora!!!', time: '10:42', isMe: false, isReported: true),
  ],
  3: [
    const _Message(text: 'Ola! Somos da TechStart e adoramos seu projeto. Tem interesse em uma parceria?', time: '09:00', isMe: false),
    const _Message(text: 'Ola! Sim, com certeza. Me conta mais!', time: '09:05', isMe: true),
    const _Message(text: 'Obrigado pela ajuda no código!', time: '09:20', isMe: false),
  ],
  4: [
    const _Message(text: 'Seu projeto ficou incrivel! Me inspiro muito nisso.', time: '08:50', isMe: false),
    const _Message(text: 'Obrigado! O seu prototipo de UX também esta ótimo!', time: '08:55', isMe: true),
    const _Message(text: 'Adorei seu prototipo!', time: '09:00', isMe: false),
  ],
};

const _kSuggestions = [
  _Suggestion(name: 'Tech Innovate', type: 'Empresa', description: 'Empresa de tecnologia procurando desenvolvedores junior com experiencia em React.', iconBg: Color(0xFFE3F2FD), iconColor: Color(0xFF1565C0), btnColor: AppColors.primary, btnLabel: 'Conectar', icon: Icons.business_outlined),
  _Suggestion(name: 'Grupo IoT Brasil', type: 'Comunidade', description: 'Comunidade de desenvolvedores IoT compartilhando conhecimento e oportunidades.', iconBg: Color(0xFFF3E5F5), iconColor: Color(0xFF6A1B9A), btnColor: Color(0xFF8E24AA), btnLabel: 'Participar', icon: Icons.people_outline),
  _Suggestion(name: 'Carlos Mendes', type: 'Recrutador Tech', description: 'Recrutador especializado em tecnologia com varias vagas abertas para junior.', iconBg: Color(0xFFE8F5E9), iconColor: Color(0xFF2E7D32), btnColor: Color(0xFF2E7D32), btnLabel: 'Conectar', icon: Icons.work_outline),
];

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class NetworkingView extends StatefulWidget {
  const NetworkingView({super.key});

  @override
  State<NetworkingView> createState() => _NetworkingViewState();
}

class _NetworkingViewState extends State<NetworkingView> {
  _Contact? _selected;
  final _msgCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late Map<int, List<_Message>> _messages;
  String _search = '';
  final Set<int> _mutedContacts = {};

  bool get _canModerate => AppSession.isProfessor || AppSession.isAdmin;
  bool get _isAdmin => AppSession.isAdmin;

  @override
  void initState() {
    super.initState();
    _selected = _kContacts[1];
    _messages = Map.fromEntries(
      _kMessages.entries.map((e) => MapEntry(e.key, List.from(e.value))),
    );
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  List<_Contact> get _filteredContacts => _kContacts
      .where((c) => c.name.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  List<({_Message msg, int contactId, int index})> get _reportedMessages {
    final result = <({_Message msg, int contactId, int index})>[];
    for (final entry in _messages.entries) {
      for (var i = 0; i < entry.value.length; i++) {
        final m = entry.value[i];
        if (m.isReported && !m.isDeleted) {
          result.add((msg: m, contactId: entry.key, index: i));
        }
      }
    }
    return result;
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _selected == null) return;
    if (_mutedContacts.contains(_selected!.id)) return;
    setState(() {
      _messages[_selected!.id] ??= [];
      _messages[_selected!.id]!.add(_Message(
        text: text,
        time: _timeNow(),
        isMe: true,
      ));
      _msgCtrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _deleteMessage(int contactId, int index) {
    setState(() {
      final msgs = _messages[contactId];
      if (msgs == null || index >= msgs.length) return;
      msgs[index] = msgs[index].copyWith(isDeleted: true);
    });
  }

  void _toggleMute(int contactId) {
    setState(() {
      if (_mutedContacts.contains(contactId)) {
        _mutedContacts.remove(contactId);
      } else {
        _mutedContacts.add(contactId);
      }
    });
  }

  String _timeNow() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context) || Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: mobile ? const AppDrawer() : null,
      body: Column(
        children: [
          const AppNavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        mobile ? 20 : 40, 28, mobile ? 20 : 40, 0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPageHeader(),
                            const SizedBox(height: 24),
                            if (_isAdmin && _reportedMessages.isNotEmpty) ...[
                              _ReportedMessagesPanel(
                                items: _reportedMessages,
                                onDelete: (contactId, index) =>
                                    _deleteMessage(contactId, index),
                              ),
                              const SizedBox(height: 16),
                            ],
                            SizedBox(
                              height: 580,
                              child: mobile
                                  ? _buildMobileChat()
                                  : _buildDesktopChat(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _SuggestionsSection(mobile: mobile),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    String? moderatorLabel;
    bool isAdminBadge = false;
    if (_isAdmin) {
      moderatorLabel = 'Administrador';
      isAdminBadge = true;
    } else if (AppSession.isProfessor) {
      moderatorLabel = 'Moderador';
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chat de Networking',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text(
                  'Conecte-se com recrutadores, empresas e outros alunos',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
        if (moderatorLabel != null)
          _ModeratorBadge(label: moderatorLabel, isAdmin: isAdminBadge),
      ],
    );
  }

  Widget _buildDesktopChat() {
    final isMuted =
        _selected != null && _mutedContacts.contains(_selected!.id);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 300,
          child: _ContactList(
            contacts: _filteredContacts,
            selected: _selected,
            searchCtrl: _searchCtrl,
            onSearch: (v) => setState(() => _search = v),
            onSelect: (c) => setState(() => _selected = c),
            mutedContacts: _mutedContacts,
            onMute: _isAdmin ? _toggleMute : null,
            onCreateChannel: _isAdmin
                ? () => _CreateChannelDialog.show(context)
                : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _selected == null
              ? _buildEmptyChat()
              : _ChatPanel(
                  contact: _selected!,
                  messages: _messages[_selected!.id] ?? [],
                  msgCtrl: _msgCtrl,
                  scrollCtrl: _scrollCtrl,
                  onSend: _sendMessage,
                  canDelete: _canModerate,
                  onDelete: (i) => _deleteMessage(_selected!.id, i),
                  isMuted: isMuted,
                ),
        ),
      ],
    );
  }

  Widget _buildMobileChat() {
    final isMuted =
        _selected != null && _mutedContacts.contains(_selected!.id);
    if (_selected != null) {
      return Column(
        children: [
          Expanded(
            child: _ChatPanel(
              contact: _selected!,
              messages: _messages[_selected!.id] ?? [],
              msgCtrl: _msgCtrl,
              scrollCtrl: _scrollCtrl,
              onSend: _sendMessage,
              onBack: () => setState(() => _selected = null),
              canDelete: _canModerate,
              onDelete: (i) => _deleteMessage(_selected!.id, i),
              isMuted: isMuted,
            ),
          ),
        ],
      );
    }
    return _ContactList(
      contacts: _filteredContacts,
      selected: _selected,
      searchCtrl: _searchCtrl,
      onSearch: (v) => setState(() => _search = v),
      onSelect: (c) => setState(() => _selected = c),
      mutedContacts: _mutedContacts,
      onMute: _isAdmin ? _toggleMute : null,
      onCreateChannel:
          _isAdmin ? () => _CreateChannelDialog.show(context) : null,
    );
  }

  Widget _buildEmptyChat() => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.textMuted),
              SizedBox(height: 12),
              Text('Selecione um contato para iniciar o chat',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
            ],
          ),
        ),
      );
}

// ─── MODERATOR BADGE ─────────────────────────────────────────────────────────
class _ModeratorBadge extends StatelessWidget {
  final String label;
  final bool isAdmin;
  const _ModeratorBadge({required this.label, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final color =
        isAdmin ? const Color(0xFF7B1FA2) : const Color(0xFF2E7D32);
    final bg = isAdmin ? const Color(0xFFF3E5F5) : const Color(0xFFE8F5E9);
    final icon = isAdmin
        ? Icons.admin_panel_settings_outlined
        : Icons.shield_outlined;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }
}

// ─── REPORTED MESSAGES PANEL (coordenador) ────────────────────────────────────
class _ReportedMessagesPanel extends StatefulWidget {
  final List<({_Message msg, int contactId, int index})> items;
  final void Function(int contactId, int index) onDelete;
  const _ReportedMessagesPanel(
      {required this.items, required this.onDelete});

  @override
  State<_ReportedMessagesPanel> createState() =>
      _ReportedMessagesPanelState();
}

class _ReportedMessagesPanelState extends State<_ReportedMessagesPanel> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFFFCC02).withValues(alpha: 0.6)),
      ),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              const Icon(Icons.flag_outlined,
                  size: 16, color: Color(0xFFF57F17)),
              const SizedBox(width: 8),
              Text(
                'Mensagens Reportadas (${widget.items.length})',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF57F17)),
              ),
              const Spacer(),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18,
                color: const Color(0xFFF57F17),
              ),
            ]),
          ),
        ),
        if (_expanded) ...[
          const Divider(height: 1, color: Color(0xFFFFECB3)),
          ...widget.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(children: [
                  const Icon(Icons.report_problem_outlined,
                      size: 14, color: Color(0xFFE65100)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item.msg.text,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 8),
                  Text(item.msg.time,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        widget.onDelete(item.contactId, item.index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.statusRejectedBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Remover',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.statusRejectedFg)),
                    ),
                  ),
                ]),
              )),
        ],
      ]),
    );
  }
}

// ─── CONTACT LIST ─────────────────────────────────────────────────────────────
class _ContactList extends StatelessWidget {
  final List<_Contact> contacts;
  final _Contact? selected;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearch;
  final ValueChanged<_Contact> onSelect;
  final Set<int> mutedContacts;
  final void Function(int)? onMute;
  final VoidCallback? onCreateChannel;

  const _ContactList({
    required this.contacts,
    required this.selected,
    required this.searchCtrl,
    required this.onSearch,
    required this.onSelect,
    required this.mutedContacts,
    this.onMute,
    this.onCreateChannel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              TextField(
                controller: searchCtrl,
                onChanged: onSearch,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar contatos...',
                  hintStyle: const TextStyle(
                      fontSize: 13, color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search,
                      size: 18, color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              if (onCreateChannel != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onCreateChannel,
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('Criar Canal',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ]),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, i) {
                final c = contacts[i];
                final isSelected = selected?.id == c.id;
                final isMuted = mutedContacts.contains(c.id);
                return GestureDetector(
                  onTap: () => onSelect(c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.07)
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(children: [
                      Stack(children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              isMuted ? AppColors.textMuted : c.avatarColor,
                          child: Text(c.initials,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                        ),
                        if (c.online && !isMuted)
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFF43A047),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                        if (isMuted)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: AppColors.statusRejectedFg,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.volume_off,
                                  size: 8, color: Colors.white),
                            ),
                          ),
                      ]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Flexible(
                                child: Text(c.name,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isMuted
                                            ? AppColors.textMuted
                                            : isSelected
                                                ? AppColors.primary
                                                : AppColors.textPrimary)),
                              ),
                              if (isMuted) ...[
                                const SizedBox(width: 4),
                                const Text('silenciado',
                                    style: TextStyle(
                                        fontSize: 9,
                                        color:
                                            AppColors.statusRejectedFg,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ]),
                            const SizedBox(height: 2),
                            Text(c.role,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted),
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(c.lastMessage,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      if (onMute != null)
                        Tooltip(
                          message: isMuted
                              ? 'Remover silêncio'
                              : 'Silenciar usuário',
                          child: GestureDetector(
                            onTap: () => onMute!(c.id),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Icon(
                                isMuted
                                    ? Icons.volume_up_outlined
                                    : Icons.volume_off_outlined,
                                size: 16,
                                color: isMuted
                                    ? AppColors.statusRejectedFg
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CHAT PANEL ───────────────────────────────────────────────────────────────
class _ChatPanel extends StatelessWidget {
  final _Contact contact;
  final List<_Message> messages;
  final TextEditingController msgCtrl;
  final ScrollController scrollCtrl;
  final VoidCallback onSend;
  final VoidCallback? onBack;
  final bool canDelete;
  final void Function(int index) onDelete;
  final bool isMuted;

  const _ChatPanel({
    required this.contact,
    required this.messages,
    required this.msgCtrl,
    required this.scrollCtrl,
    required this.onSend,
    this.onBack,
    required this.canDelete,
    required this.onDelete,
    required this.isMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        // Header
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(children: [
            if (onBack != null) ...[
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back,
                    size: 20, color: AppColors.textSecondary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
            ],
            CircleAvatar(
              radius: 20,
              backgroundColor:
                  isMuted ? AppColors.textMuted : contact.avatarColor,
              child: Text(contact.initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Flexible(
                      child: Text(contact.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isMuted
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary)),
                    ),
                    if (isMuted) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.volume_off,
                          size: 13,
                          color: AppColors.statusRejectedFg),
                    ],
                  ]),
                  Text(
                    isMuted ? 'Usuário silenciado' : contact.role,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11,
                        color: isMuted
                            ? AppColors.statusRejectedFg
                            : AppColors.textMuted),
                  ),
                ],
              ),
            ),
            if (contact.badge.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCE93D8)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.business_center_outlined,
                      size: 12, color: Color(0xFF7B1FA2)),
                  const SizedBox(width: 4),
                  Text(contact.badge,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7B1FA2))),
                ]),
              ),
          ]),
        ),

        // Mensagens
        Expanded(
          child: ListView.builder(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(20),
            itemCount: messages.length,
            itemBuilder: (context, i) => _MessageBubble(
              msg: messages[i],
              contact: contact,
              canDelete: canDelete,
              onDelete: () => onDelete(i),
            ),
          ),
        ),

        // Input
        if (isMuted)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppColors.border))),
            child: const Row(children: [
              Icon(Icons.volume_off,
                  size: 15, color: AppColors.statusRejectedFg),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Usuário silenciado — remova o silêncio para interagir.',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            ]),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppColors.border))),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: msgCtrl,
                  style: const TextStyle(fontSize: 13),
                  onSubmitted: (_) => onSend(),
                  decoration: InputDecoration(
                    hintText: 'Digite sua mensagem...',
                    hintStyle: const TextStyle(
                        fontSize: 13, color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: onSend,
                icon: const Icon(Icons.send_outlined, size: 16),
                label: const Text('Enviar',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ]),
          ),
      ]),
    );
  }
}

// ─── MESSAGE BUBBLE ───────────────────────────────────────────────────────────
class _MessageBubble extends StatefulWidget {
  final _Message msg;
  final _Contact contact;
  final bool canDelete;
  final VoidCallback onDelete;

  const _MessageBubble({
    required this.msg,
    required this.contact,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final msg = widget.msg;
    final contact = widget.contact;

    // Soft-deleted placeholder
    if (msg.isDeleted) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment:
              msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.delete_outline,
                    size: 12, color: AppColors.textMuted),
                SizedBox(width: 4),
                Text('[Mensagem removida pelo moderador]',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic)),
              ]),
            ),
          ],
        ),
      );
    }

    final bubbleColor = msg.isReported
        ? const Color(0xFFFFF3E0)
        : msg.isMe
            ? AppColors.primary
            : const Color(0xFFF3F4F6);
    final textColor = msg.isReported
        ? AppColors.textPrimary
        : msg.isMe
            ? Colors.white
            : AppColors.textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!msg.isMe) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: contact.avatarColor,
                child: Text(contact.initials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Row(
                mainAxisAlignment: msg.isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Delete btn left (for my messages)
                  if (widget.canDelete && msg.isMe && _hovered) ...[
                    _DeleteBtn(onTap: widget.onDelete),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: msg.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (msg.isReported)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.flag,
                                      size: 11,
                                      color: Color(0xFFE65100)),
                                  SizedBox(width: 3),
                                  Text('Reportada',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFE65100),
                                          fontWeight: FontWeight.w600)),
                                ]),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          constraints:
                              const BoxConstraints(maxWidth: 380),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            border: msg.isReported
                                ? Border.all(
                                    color: const Color(0xFFFFCC02)
                                        .withValues(alpha: 0.6))
                                : null,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft:
                                  Radius.circular(msg.isMe ? 16 : 4),
                              bottomRight:
                                  Radius.circular(msg.isMe ? 4 : 16),
                            ),
                          ),
                          child: Text(msg.text,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: textColor,
                                  height: 1.5)),
                        ),
                        const SizedBox(height: 4),
                        Text(msg.time,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  // Delete btn right (for others' messages)
                  if (widget.canDelete && !msg.isMe && _hovered) ...[
                    const SizedBox(width: 6),
                    _DeleteBtn(onTap: widget.onDelete),
                  ],
                ],
              ),
            ),
            if (msg.isMe) ...[
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.secondary,
                child: Text('VC',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DeleteBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _DeleteBtn({required this.onTap});

  @override
  Widget build(BuildContext context) => Tooltip(
        message: 'Remover mensagem',
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.statusRejectedBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.delete_outline,
                size: 14, color: AppColors.statusRejectedFg),
          ),
        ),
      );
}

// ─── DIALOG: CRIAR CANAL (coordenador) ───────────────────────────────────────
class _CreateChannelDialog extends StatefulWidget {
  static void show(BuildContext context) {
    showDialog(context: context, builder: (_) => const _CreateChannelDialog());
  }

  const _CreateChannelDialog();

  @override
  State<_CreateChannelDialog> createState() => _CreateChannelDialogState();
}

class _CreateChannelDialogState extends State<_CreateChannelDialog> {
  final _nameCtrl = TextEditingController();
  bool _created = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 400,
          child: _created
              ? Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.check_circle_outline,
                      size: 40, color: AppColors.statusApprovedFg),
                  const SizedBox(height: 12),
                  Text(
                    'Canal "${_nameCtrl.text}" criado!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                ])
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Criar Novo Canal',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    const Text(
                        'O canal ficará visível para todos os membros.',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameCtrl,
                      autofocus: true,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Nome do canal',
                        hintText: 'Ex: ADS 2024.1 — Geral',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_nameCtrl.text.trim().isEmpty) return;
                            setState(() => _created = true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Criar',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ]),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── SUGGESTIONS ─────────────────────────────────────────────────────────────
class _SuggestionsSection extends StatelessWidget {
  final bool mobile;
  const _SuggestionsSection({required this.mobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          mobile ? 20 : 40, 0, mobile ? 20 : 40, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sugestoes de Networking',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              mobile
                  ? Column(
                      children: _kSuggestions
                          .map((s) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 16),
                                child: _SuggestionCard(suggestion: s),
                              ))
                          .toList(),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _kSuggestions
                          .map((s) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: _kSuggestions.indexOf(s) <
                                              _kSuggestions.length - 1
                                          ? 20
                                          : 0),
                                  child: _SuggestionCard(suggestion: s),
                                ),
                              ))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatefulWidget {
  final _Suggestion suggestion;
  const _SuggestionCard({required this.suggestion});

  @override
  State<_SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<_SuggestionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.suggestion;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? s.btnColor.withValues(alpha: 0.4)
                  : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: s.btnColor.withValues(alpha: 0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: s.iconBg,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(s.icon, color: s.iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      Text(s.type,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              Text(s.description,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.6)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: s.btnColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(s.btnLabel,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── PORTFÓLIO PARA EMPRESA PARCEIRA ─────────────────────────────────────────
class _EmpresaPortfolioView extends StatefulWidget {
  @override
  State<_EmpresaPortfolioView> createState() =>
      _EmpresaPortfolioViewState();
}

class _EmpresaPortfolioViewState extends State<_EmpresaPortfolioView> {
  String _filtroTech = 'Todas';
  String? _interessado;

  static const _projetos = [
    _ProjetoEmpresa(id: 1, titulo: 'Sistema de Automação Residencial', aluno: 'Carlos Silva', turma: 'ADS 2024.1', descricao: 'Plataforma IoT para controle automatizado de dispositivos residenciais via app mobile com integração MQTT.', techs: ['Flutter', 'Node.js', 'MQTT', 'PostgreSQL'], nota: 9.0, linkedin: '@carlos.silva'),
    _ProjetoEmpresa(id: 2, titulo: 'App de Gestão Acadêmica', aluno: 'Ana Ferreira', turma: 'ADS 2024.1', descricao: 'Aplicativo para gerenciamento de notas, frequências e comunicação entre alunos e professores.', techs: ['Flutter', 'Firebase', 'Dart'], nota: 8.5, linkedin: '@ana.ferreira'),
    _ProjetoEmpresa(id: 3, titulo: 'E-commerce Sustentável', aluno: 'Pedro Costa', turma: 'ADS 2023.2', descricao: 'Marketplace focado em produtos sustentáveis com rastreabilidade de cadeia de produção.', techs: ['Vue.js', 'Laravel', 'MySQL'], nota: 8.0, linkedin: '@pedro.costa'),
    _ProjetoEmpresa(id: 4, titulo: 'Dashboard Analytics B2B', aluno: 'Juliana Lima', turma: 'GTI 2024.1', descricao: 'Painel de análise de dados em tempo real para tomada de decisão empresarial.', techs: ['React', 'Python', 'PostgreSQL', 'Chart.js'], nota: 9.5, linkedin: '@juliana.lima'),
    _ProjetoEmpresa(id: 5, titulo: 'App de Delivery Local', aluno: 'Ricardo Mendes', turma: 'ADS 2024.2', descricao: 'Plataforma de delivery para comércios locais com rastreamento em tempo real.', techs: ['React Native', 'Node.js', 'MongoDB'], nota: 8.8, linkedin: '@ricardo.mendes'),
    _ProjetoEmpresa(id: 6, titulo: 'Sistema de Agendamento Médico', aluno: 'Fernanda Souza', turma: 'DS 2024.1', descricao: 'Plataforma de agendamento de consultas com prontuário eletrônico simplificado.', techs: ['Flutter', 'Firebase', 'Dart', 'SQLite'], nota: 9.2, linkedin: '@fernanda.souza'),
  ];

  List<String> get _todasTechs {
    final set = <String>{'Todas'};
    for (final p in _projetos) {
      set.addAll(p.techs);
    }
    return set.toList()..sort();
  }

  List<_ProjetoEmpresa> get _filtrados => _filtroTech == 'Todas'
      ? _projetos
      : _projetos.where((p) => p.techs.contains(_filtroTech)).toList();

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: mobile ? const AppDrawer() : null,
      body: Column(children: [
        const AppNavBar(),
        Expanded(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        mobile ? 16 : 40, 28, mobile ? 16 : 40, 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF3E5F5),
                                      borderRadius:
                                          BorderRadius.circular(12)),
                                  child: const Icon(
                                      Icons.business_center_outlined,
                                      color: Color(0xFF7B1FA2),
                                      size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Portfólio de Talentos',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  AppColors.textPrimary)),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${_filtrados.length} projetos disponíveis · Identifique e recrute novos talentos',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color:
                                                AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _todasTechs.map((tech) {
                                  final ativo = _filtroTech == tech;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () => setState(
                                          () => _filtroTech = tech),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                            milliseconds: 200),
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ativo
                                              ? const Color(0xFF7B1FA2)
                                              : AppColors.surface,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: ativo
                                                  ? const Color(
                                                      0xFF7B1FA2)
                                                  : AppColors.border),
                                        ),
                                        child: Text(tech,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w600,
                                                color: ativo
                                                    ? Colors.white
                                                    : AppColors
                                                        .textSecondary)),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 24),
                            mobile
                                ? Column(
                                    children: _filtrados
                                        .map((p) => Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      bottom: 16),
                                              child: _ProjetoCard(
                                                projeto: p,
                                                interessado:
                                                    _interessado ==
                                                        '${p.id}',
                                                onInteresse: () =>
                                                    setState(() =>
                                                        _interessado =
                                                            '${p.id}'),
                                              ),
                                            ))
                                        .toList())
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          Responsive.isTablet(context)
                                              ? 2
                                              : 3,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemCount: _filtrados.length,
                                    itemBuilder: (_, i) => _ProjetoCard(
                                      projeto: _filtrados[i],
                                      interessado: _interessado ==
                                          '${_filtrados[i].id}',
                                      onInteresse: () => setState(() =>
                                          _interessado =
                                              '${_filtrados[i].id}'),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _ProjetoEmpresa {
  final int id;
  final String titulo, aluno, turma, descricao, linkedin;
  final List<String> techs;
  final double nota;
  const _ProjetoEmpresa({
    required this.id,
    required this.titulo,
    required this.aluno,
    required this.turma,
    required this.descricao,
    required this.linkedin,
    required this.techs,
    required this.nota,
  });
}

class _ProjetoCard extends StatelessWidget {
  final _ProjetoEmpresa projeto;
  final bool interessado;
  final VoidCallback onInteresse;
  const _ProjetoCard(
      {required this.projeto,
      required this.interessado,
      required this.onInteresse});

  @override
  Widget build(BuildContext context) {
    final p = projeto;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: interessado
                ? const Color(0xFF7B1FA2)
                : AppColors.border,
            width: interessado ? 2 : 1),
        boxShadow: interessado
            ? [
                BoxShadow(
                    color: const Color(0xFF7B1FA2).withValues(alpha: 0.12),
                    blurRadius: 16)
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE8EAF6),
              child: Text(
                p.aluno.split(' ').map((w) => w[0]).take(2).join(),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3949AB)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.aluno,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  Text(p.turma,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.statusApprovedBg,
                  borderRadius: BorderRadius.circular(8)),
              child: Text('⭐ ${p.nota.toStringAsFixed(1)}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.statusApprovedFg)),
            ),
          ]),
          const SizedBox(height: 14),
          Text(p.titulo,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(p.descricao,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: p.techs
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEDE7F6),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(t,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4527A0)))))
                .toList(),
          ),
          const Spacer(),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Ver Projeto',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: interessado ? null : onInteresse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: interessado
                      ? AppColors.statusApprovedFg
                      : const Color(0xFF7B1FA2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(interessado ? '✓ Interesse' : 'Recrutar',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
