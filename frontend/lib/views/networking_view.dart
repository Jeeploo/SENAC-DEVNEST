import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
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

  const _Message({required this.text, required this.time, required this.isMe});
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
  _Contact(
    id: 1,
    name: 'Joao Silva',
    initials: 'JS',
    role: 'Desenvolvedor Full Stack',
    lastMessage: 'Ótimo! Podemos marcar uma reuniao?',
    online: true,
    avatarColor: Color(0xFF5C6BC0),
    badge: 'Aluno',
  ),
  _Contact(
    id: 2,
    name: 'Maria Santos',
    initials: 'MS',
    role: 'Recrutadora - Tech Corp',
    lastMessage: 'Vi seu projeto de IoT, muito interessante!',
    online: true,
    avatarColor: Color(0xFF8E24AA),
    badge: 'Recrutador',
  ),
  _Contact(
    id: 3,
    name: 'Pedro Costa',
    initials: 'PC',
    role: 'Engenheiro de Software',
    lastMessage: 'Obrigado pela ajuda no código!',
    online: false,
    avatarColor: Color(0xFF00838F),
    badge: 'Empresa',
  ),
  _Contact(
    id: 4,
    name: 'Ana Lima',
    initials: 'AL',
    role: 'Designer UX/UI',
    lastMessage: 'Adorei seu prototipo!',
    online: true,
    avatarColor: Color(0xFFE53935),
    badge: 'Aluno',
  ),
];

final _kMessages = {
  1: [
    const _Message(
      text:
          'Oi! Vi seu perfil no SENAC DevNest. Seu projeto de automacao e incrivel!',
      time: '10:10',
      isMe: false,
    ),
    const _Message(
      text: 'Que legal, obrigado! Trabalhei muito nele.',
      time: '10:12',
      isMe: true,
    ),
    const _Message(
      text: 'Ótimo! Podemos marcar uma reuniao?',
      time: '10:15',
      isMe: false,
    ),
    const _Message(
      text: 'Claro, quando voce preferir!',
      time: '10:17',
      isMe: true,
    ),
  ],
  2: [
    const _Message(
      text:
          'Ola! Vi seu projeto de Sistema de Automacao Residencial no Observatório PI.',
      time: '10:30',
      isMe: false,
    ),
    const _Message(
      text: 'Ola Maria! Obrigado pelo interesse. Como posso ajudar?',
      time: '10:32',
      isMe: true,
    ),
    const _Message(
      text:
          'Trabalho na Tech Corp e estamos procurando desenvolvedores com experiencia em IoT. Voce tem interesse em oportunidades?',
      time: '10:35',
      isMe: false,
    ),
    const _Message(
      text: 'Sim, tenho muito interesse! Pode me contar mais sobre a vaga?',
      time: '10:37',
      isMe: true,
    ),
    const _Message(
      text:
          'Claro! E uma posição de desenvolvedor junior focada em solucoes IoT. Vou te enviar mais detalhes por email.',
      time: '10:40',
      isMe: false,
    ),
  ],
  3: [
    const _Message(
      text:
          'Ola! Somos da TechStart e adoramos seu projeto. Tem interesse em uma parceria?',
      time: '09:00',
      isMe: false,
    ),
    const _Message(
      text: 'Ola! Sim, com certeza. Me conta mais!',
      time: '09:05',
      isMe: true,
    ),
    const _Message(
      text: 'Obrigado pela ajuda no código!',
      time: '09:20',
      isMe: false,
    ),
  ],
  4: [
    const _Message(
      text: 'Seu projeto ficou incrivel! Me inspiro muito nisso.',
      time: '08:50',
      isMe: false,
    ),
    const _Message(
      text: 'Obrigado! O seu prototipo de UX também esta ótimo!',
      time: '08:55',
      isMe: true,
    ),
    const _Message(text: 'Adorei seu prototipo!', time: '09:00', isMe: false),
  ],
};

const _kSuggestions = [
  _Suggestion(
    name: 'Tech Innovate',
    type: 'Empresa',
    description:
        'Empresa de tecnologia procurando desenvolvedores junior com experiencia em React.',
    iconBg: Color(0xFFE3F2FD),
    iconColor: Color(0xFF1565C0),
    btnColor: AppColors.primary,
    btnLabel: 'Conectar',
    icon: Icons.business_outlined,
  ),
  _Suggestion(
    name: 'Grupo IoT Brasil',
    type: 'Comunidade',
    description:
        'Comunidade de desenvolvedores IoT compartilhando conhecimento e oportunidades.',
    iconBg: Color(0xFFF3E5F5),
    iconColor: Color(0xFF6A1B9A),
    btnColor: Color(0xFF8E24AA),
    btnLabel: 'Participar',
    icon: Icons.people_outline,
  ),
  _Suggestion(
    name: 'Carlos Mendes',
    type: 'Recrutador Tech',
    description:
        'Recrutador especializado em tecnologia com varias vagas abertas para junior.',
    iconBg: Color(0xFFE8F5E9),
    iconColor: Color(0xFF2E7D32),
    btnColor: Color(0xFF2E7D32),
    btnLabel: 'Conectar',
    icon: Icons.work_outline,
  ),
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

  @override
  void initState() {
    super.initState();
    _selected = _kContacts[1]; // Maria Santos selecionada por padrão
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

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _selected == null) return;
    setState(() {
      _messages[_selected!.id] ??= [];
      _messages[_selected!.id]!.add(
        _Message(text: text, time: _timeNow(), isMe: true),
      );
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
                  // Header + Chat
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      mobile ? 20 : 40,
                      28,
                      mobile ? 20 : 40,
                      0,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chat de Networking',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Conecte-se com recrutadores, empresas e outros alunos',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
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
                  // Suggestions
                  _SuggestionsSection(mobile: mobile),
                  const SizedBox(height: 40),
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopChat() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Lista de contatos
        SizedBox(
          width: 300,
          child: _ContactList(
            contacts: _filteredContacts,
            selected: _selected,
            searchCtrl: _searchCtrl,
            onSearch: (v) => setState(() => _search = v),
            onSelect: (c) => setState(() => _selected = c),
          ),
        ),
        const SizedBox(width: 16),
        // Painel de chat
        Expanded(
          child: _selected == null
              ? _buildEmptyChat()
              : _ChatPanel(
                  contact: _selected!,
                  messages: _messages[_selected!.id] ?? [],
                  msgCtrl: _msgCtrl,
                  scrollCtrl: _scrollCtrl,
                  onSend: _sendMessage,
                ),
        ),
      ],
    );
  }

  Widget _buildMobileChat() {
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
    );
  }

  Widget _buildEmptyChat() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 12),
            Text(
              'Selecione um contato para iniciar o chat',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
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

  const _ContactList({
    required this.contacts,
    required this.selected,
    required this.searchCtrl,
    required this.onSearch,
    required this.onSelect,
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
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchCtrl,
              onChanged: onSearch,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar contatos...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          // Contacts
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, i) {
                final c = contacts[i];
                final isSelected = selected?.id == c.id;
                return GestureDetector(
                  onTap: () => onSelect(c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.07)
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: c.avatarColor,
                              child: Text(
                                c.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (c.online)
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
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c.role,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c.lastMessage,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  const _ChatPanel({
    required this.contact,
    required this.messages,
    required this.msgCtrl,
    required this.scrollCtrl,
    required this.onSend,
    this.onBack,
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
          // Header do chat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                if (onBack != null) ...[
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                ],
                CircleAvatar(
                  radius: 20,
                  backgroundColor: contact.avatarColor,
                  child: Text(
                    contact.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        contact.role,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (contact.badge.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFCE93D8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.business_center_outlined,
                          size: 12,
                          color: Color(0xFF7B1FA2),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          contact.badge,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7B1FA2),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Mensagens
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, i) =>
                  _MessageBubble(msg: messages[i], contact: contact),
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    style: const TextStyle(fontSize: 13),
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: onSend,
                  icon: const Icon(Icons.send_outlined, size: 16),
                  label: const Text(
                    'Enviar',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

// ─── MESSAGE BUBBLE ───────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final _Message msg;
  final _Contact contact;

  const _MessageBubble({required this.msg, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: msg.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!msg.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: contact.avatarColor,
              child: Text(
                contact.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  constraints: const BoxConstraints(maxWidth: 380),
                  decoration: BoxDecoration(
                    color: msg.isMe
                        ? AppColors.primary
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(msg.isMe ? 16 : 4),
                      bottomRight: Radius.circular(msg.isMe ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 13,
                      color: msg.isMe ? Colors.white : AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  msg.time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (msg.isMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.secondary,
              child: Text(
                'VC',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
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
      padding: EdgeInsets.fromLTRB(mobile ? 20 : 40, 0, mobile ? 20 : 40, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sugestoes de Networking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              mobile
                  ? Column(
                      children: _kSuggestions
                          .map(
                            (s) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _SuggestionCard(suggestion: s),
                            ),
                          )
                          .toList(),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _kSuggestions
                          .map(
                            (s) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      _kSuggestions.indexOf(s) <
                                          _kSuggestions.length - 1
                                      ? 20
                                      : 0,
                                ),
                                child: _SuggestionCard(suggestion: s),
                              ),
                            ),
                          )
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
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: s.iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          s.type,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                s.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    s.btnLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
