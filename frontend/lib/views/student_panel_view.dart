import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';

// ─── MODELS ──────────────────────────────────────────────────────────────────
enum _StudentStatus { approved, pending, rejected }

class _StudentProject {
  final int id;
  final String title;
  final String classGroup;
  final String date;
  final _StudentStatus status;
  final String description;
  final List<String> technologies;
  final String? githubLink;
  final String? demoLink;
  final String? rejectionReason;

  const _StudentProject({
    required this.id,
    required this.title,
    required this.classGroup,
    required this.date,
    required this.status,
    this.description = '',
    this.technologies = const [],
    this.githubLink,
    this.demoLink,
    this.rejectionReason,
  });
}

const _kTurmas = ['ADS 2024.1','ADS 2024.2','ADS 2023.1','ADS 2023.2','GTI 2024.1','GTI 2024.2','DS 2024.1','DS 2023.2'];

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class StudentPanelView extends StatefulWidget {
  const StudentPanelView({super.key});
  @override
  State<StudentPanelView> createState() => _StudentPanelViewState();
}

class _StudentPanelViewState extends State<StudentPanelView> {
  bool _showForm = false;
  late List<_StudentProject> _projects;

  // Form state
  final _nameCtrl  = TextEditingController();
  final _coCtrl    = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _techCtrl  = TextEditingController();
  final _repoCtrl  = TextEditingController();
  final _demoCtrl  = TextEditingController();
  String? _selectedTurma;
  List<String> _techTags = [];

  @override
  void initState() {
    super.initState();
    _projects = [
      const _StudentProject(
        id:1, title:'Sistema de Automacao Residencial',
        classGroup:'ADS 2024.1', date:'14/03/2024',
        status:_StudentStatus.approved,
        description:'Plataforma IoT para controle automatizado de dispositivos residenciais via app mobile.',
        technologies:['React Native','Node.js','MQTT','PostgreSQL'],
        githubLink:'https://github.com/usuario/automacao-residencial',
        demoLink:'https://automacao-demo.vercel.app',
      ),
      const _StudentProject(
        id:2, title:'App de Gestao Academica',
        classGroup:'ADS 2024.1', date:'01/04/2024',
        status:_StudentStatus.pending,
        description:'Aplicativo para gerenciamento de notas, frequencias e comunicacao entre alunos e professores.',
        technologies:['Flutter','Firebase','Dart'],
        githubLink:'https://github.com/usuario/gestao-academica',
      ),
      const _StudentProject(
        id:3, title:'Plataforma E-commerce Sustentavel',
        classGroup:'ADS 2023.2', date:'19/11/2023',
        status:_StudentStatus.rejected,
        description:'Marketplace focado em produtos sustentaveis com rastreabilidade de cadeia de producao.',
        technologies:['Vue.js','Laravel','MySQL'],
        githubLink:'https://github.com/usuario/ecommerce-sustentavel',
        rejectionReason:'A documentacao tecnica esta incompleta e o sistema nao atende aos requisitos minimos de seguranca definidos no edital. Solicita-se revisao e nova submissao.',
      ),
    ];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();_coCtrl.dispose();_descCtrl.dispose();
    _techCtrl.dispose();_repoCtrl.dispose();_demoCtrl.dispose();
    super.dispose();
  }

  void _resetForm() {
    _nameCtrl.clear();_coCtrl.clear();_descCtrl.clear();
    _techCtrl.clear();_repoCtrl.clear();_demoCtrl.clear();
    setState(() { _selectedTurma=null; _techTags=[]; _showForm=false; });
  }

  void _submitForm() {
    if (_nameCtrl.text.trim().isEmpty || _selectedTurma==null) return;
    final now=DateTime.now();
    final date='${now.day.toString().padLeft(2,'0')}/${now.month.toString().padLeft(2,'0')}/${now.year}';
    setState(() {
      _projects.insert(0,_StudentProject(
        id:now.millisecondsSinceEpoch,title:_nameCtrl.text.trim(),
        classGroup:_selectedTurma!,date:date,status:_StudentStatus.pending));
    });
    _resetForm();
  }

  void _deleteProject(int id) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => _ConfirmDeleteDialog(
        onConfirm: () {
          setState(() => _projects.removeWhere((p) => p.id == id));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _addTag(String value) {
    final t=value.trim();
    if (t.isNotEmpty && !_techTags.contains(t)) {
      setState(() { _techTags.add(t); _techCtrl.clear(); });
    }
  }

  int get _total    => _projects.length;
  int get _pending  => _projects.where((p)=>p.status==_StudentStatus.pending).length;
  int get _approved => _projects.where((p)=>p.status==_StudentStatus.approved).length;
  int get _rejected => _projects.where((p)=>p.status==_StudentStatus.rejected).length;

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final hPad   = mobile ? 16.0 : 40.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: mobile ? const AppDrawer() : null,
      body: Column(children:[
        const AppNavBar(),
        Expanded(child: SingleChildScrollView(child: Column(children:[
          Padding(
            padding: EdgeInsets.fromLTRB(hPad,28,hPad,32),
            child: Center(child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth:1200),
              child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[

                // ── Header
                Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Container(width:44,height:44,
                    decoration:BoxDecoration(color:AppColors.primary.withValues(alpha:0.12),borderRadius:BorderRadius.circular(12)),
                    child:const Icon(Icons.menu_book_outlined,color:AppColors.primary,size:24)),
                  const SizedBox(width:14),
                  Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    Text('Meu Espaco de Projetos',
                        style:TextStyle(fontSize:mobile?20:26,fontWeight:FontWeight.w800,color:AppColors.textPrimary)),
                    const SizedBox(height:4),
                    const Text('Submeta novos PIs e acompanhe o status de aprovacao',
                        style:TextStyle(fontSize:13,color:AppColors.textSecondary)),
                  ])),
                  const SizedBox(width:16),
                  if (!_showForm)
                    ElevatedButton.icon(
                      onPressed: ()=>setState(()=>_showForm=true),
                      icon:const Icon(Icons.add_circle_outline,size:18),
                      label:const Text('Novo Projeto',style:TextStyle(fontSize:13,fontWeight:FontWeight.w600)),
                      style:ElevatedButton.styleFrom(
                        backgroundColor:AppColors.primary,foregroundColor:Colors.white,elevation:0,
                        padding:EdgeInsets.symmetric(horizontal:mobile?14:22,vertical:12),
                        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
                    ),
                ]),
                const SizedBox(height:24),

                // ── Stat Cards
                _StatsRow(total:_total,pending:_pending,approved:_approved,rejected:_rejected,mobile:mobile),
                const SizedBox(height:20),

                // ── Inline Form
                if (_showForm) ...[
                  _NewProjectForm(
                    nameCtrl:_nameCtrl, coCtrl:_coCtrl, descCtrl:_descCtrl,
                    techCtrl:_techCtrl, repoCtrl:_repoCtrl, demoCtrl:_demoCtrl,
                    selectedTurma:_selectedTurma, techTags:_techTags, mobile:mobile,
                    onTurmaChanged:(v)=>setState(()=>_selectedTurma=v),
                    onAddTag:_addTag,
                    onRemoveTag:(t)=>setState(()=>_techTags.remove(t)),
                    onSubmit:_submitForm,
                    onCancel:_resetForm,
                  ),
                  const SizedBox(height:20),
                ],

                // ── Histórico
                Container(
                  padding:const EdgeInsets.all(24),
                  decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppColors.border)),
                  child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    const Text('Historico de Projetos',
                        style:TextStyle(fontSize:17,fontWeight:FontWeight.w700,color:AppColors.textPrimary)),
                    const SizedBox(height:4),
                    const Text('Todos os seus projetos submetidos a plataforma',
                        style:TextStyle(fontSize:12,color:AppColors.textMuted)),
                    const SizedBox(height:20),
                    mobile
                        ? _MobileList(projects:_projects, onDelete:_deleteProject)
                        : _DesktopTable(projects:_projects, onDelete:_deleteProject),
                  ]),
                ),
              ]),
            )),
          ),
          const AppFooter(),
        ]))),
      ]),
    );
  }
}

// ─── INLINE FORM ─────────────────────────────────────────────────────────────
class _NewProjectForm extends StatelessWidget {
  final TextEditingController nameCtrl,coCtrl,descCtrl,techCtrl,repoCtrl,demoCtrl;
  final String? selectedTurma;
  final List<String> techTags;
  final bool mobile;
  final ValueChanged<String?> onTurmaChanged;
  final ValueChanged<String> onAddTag;
  final ValueChanged<String> onRemoveTag;
  final VoidCallback onSubmit, onCancel;

  const _NewProjectForm({
    required this.nameCtrl,required this.coCtrl,required this.descCtrl,
    required this.techCtrl,required this.repoCtrl,required this.demoCtrl,
    required this.selectedTurma,required this.techTags,required this.mobile,
    required this.onTurmaChanged,required this.onAddTag,required this.onRemoveTag,
    required this.onSubmit,required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(16),border:Border.all(color:AppColors.border)),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        // Header do form
        Container(
          padding:const EdgeInsets.fromLTRB(28,24,28,20),
          decoration:BoxDecoration(
            gradient:LinearGradient(colors:[AppColors.primary.withValues(alpha:0.08),Colors.transparent],
                begin:Alignment.topLeft,end:Alignment.bottomRight),
            borderRadius:const BorderRadius.vertical(top:Radius.circular(16)),
          ),
          child:Row(children:[
            Container(width:40,height:40,
              decoration:BoxDecoration(color:AppColors.primary,borderRadius:BorderRadius.circular(10)),
              child:const Icon(Icons.add_circle_outline,color:Colors.white,size:22)),
            const SizedBox(width:14),
            const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('Nova Submissao',style:TextStyle(fontSize:18,fontWeight:FontWeight.w700,color:AppColors.textPrimary)),
              Text('Preencha os dados do seu Projeto Integrador',style:TextStyle(fontSize:12,color:AppColors.textSecondary)),
            ])),
            IconButton(onPressed:onCancel,icon:const Icon(Icons.close,size:20,color:AppColors.textMuted),
                padding:EdgeInsets.zero,constraints:const BoxConstraints()),
          ]),
        ),
        const Divider(height:1,color:AppColors.border),

        // Campos
        Padding(padding:const EdgeInsets.all(28),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[

          // Nome + Turma
          mobile
            ? Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                _label('Nome do Projeto *'),
                _textField(nameCtrl,'Ex: Sistema de Gestao de Estoque'),
                const SizedBox(height:16),
                _label('Turma *'),
                _dropdown(selectedTurma,onTurmaChanged),
              ])
            : Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  _label('Nome do Projeto *'),
                  _textField(nameCtrl,'Ex: Sistema de Gestao de Estoque'),
                ])),
                const SizedBox(width:20),
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  _label('Turma *'),
                  _dropdown(selectedTurma,onTurmaChanged),
                ])),
              ]),
          const SizedBox(height:20),

          // Coorientador
          _label('Coorientador'),
          _textField(coCtrl,'Nome do professor coorientador (opcional)'),
          const SizedBox(height:20),

          // Descrição
          _label('Descricao Completa *'),
          _textField(descCtrl,'Descreva o objetivo, metodologia e resultados esperados do projeto...',maxLines:5),
          const SizedBox(height:20),

          // Tecnologias (tag input)
          Row(children:[
            const Text('Tecnologias',style:TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppColors.textPrimary)),
            const SizedBox(width:6),
            Text('(Digite e pressione Enter)',style:TextStyle(fontSize:11,color:AppColors.primary)),
          ]),
          const SizedBox(height:6),
          Container(
            padding:const EdgeInsets.symmetric(horizontal:12,vertical:10),
            decoration:BoxDecoration(color:AppColors.background,borderRadius:BorderRadius.circular(10),
                border:Border.all(color:AppColors.border)),
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              if (techTags.isNotEmpty) Padding(
                padding:const EdgeInsets.only(bottom:8),
                child:Wrap(spacing:6,runSpacing:6,
                  children:techTags.map((t)=>Container(
                    padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
                    decoration:BoxDecoration(color:AppColors.primary.withValues(alpha:0.1),borderRadius:BorderRadius.circular(20)),
                    child:Row(mainAxisSize:MainAxisSize.min,children:[
                      Text(t,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w500,color:AppColors.primary)),
                      const SizedBox(width:4),
                      GestureDetector(onTap:()=>onRemoveTag(t),
                        child:const Icon(Icons.close,size:12,color:AppColors.primary)),
                    ]),
                  )).toList()),
              ),
              TextField(controller:techCtrl,style:const TextStyle(fontSize:13),
                onSubmitted:onAddTag,
                decoration:const InputDecoration(hintText:'React, Node.js, Python...',
                  hintStyle:TextStyle(fontSize:13,color:AppColors.textMuted),
                  border:InputBorder.none,isDense:true,contentPadding:EdgeInsets.zero)),
            ]),
          ),
          const SizedBox(height:20),

          // Repo + Demo
          mobile
            ? Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                _linkField(Icons.code,'Link do Repositorio',repoCtrl,'https://github.com/usuario/projeto'),
                const SizedBox(height:16),
                _linkField(Icons.open_in_new,'Link da Demo Live',demoCtrl,'https://meu-projeto.vercel.app'),
              ])
            : Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Expanded(child:_linkField(Icons.code,'Link do Repositorio',repoCtrl,'https://github.com/usuario/projeto')),
                const SizedBox(width:20),
                Expanded(child:_linkField(Icons.open_in_new,'Link da Demo Live',demoCtrl,'https://meu-projeto.vercel.app')),
              ]),
          const SizedBox(height:20),

          // Upload
          _label('Documentos do Projeto'),
          const SizedBox(height:6),
          Container(
            width:double.infinity,
            padding:const EdgeInsets.symmetric(vertical:32),
            decoration:BoxDecoration(
              color:AppColors.background,
              borderRadius:BorderRadius.circular(10),
              border:Border.all(color:AppColors.border,style:BorderStyle.solid,width:1.5),
            ),
            child:Column(children:[
              Icon(Icons.upload_outlined,size:32,color:AppColors.textMuted),
              const SizedBox(height:8),
              const Text('Clique para fazer upload ou arraste aqui',
                  style:TextStyle(fontSize:13,color:AppColors.textSecondary,fontWeight:FontWeight.w500)),
              const SizedBox(height:4),
              const Text('PDF, DOCX, ZIP (max. 20MB)',
                  style:TextStyle(fontSize:11,color:AppColors.textMuted)),
            ]),
          ),
          const SizedBox(height:28),

          // Botões
          Wrap(spacing:12,runSpacing:12,children:[
            ElevatedButton(
              onPressed:onSubmit,
              style:ElevatedButton.styleFrom(
                backgroundColor:AppColors.primary,foregroundColor:Colors.white,elevation:0,
                padding:const EdgeInsets.symmetric(horizontal:28,vertical:14),
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
              child:const Text('Submeter para Aprovacao',style:TextStyle(fontSize:14,fontWeight:FontWeight.w600)),
            ),
            OutlinedButton(
              onPressed:onCancel,
              style:OutlinedButton.styleFrom(foregroundColor:AppColors.textSecondary,
                  side:const BorderSide(color:AppColors.border),
                  padding:const EdgeInsets.symmetric(horizontal:24,vertical:14),
                  shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
              child:const Text('Cancelar',style:TextStyle(fontSize:14)),
            ),
          ]),
        ])),
      ]),
    );
  }

  Widget _label(String text) => Padding(
    padding:const EdgeInsets.only(bottom:6),
    child:Text(text,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppColors.textPrimary)),
  );

  Widget _textField(TextEditingController ctrl,String hint,{int maxLines=1}) => TextField(
    controller:ctrl,maxLines:maxLines,style:const TextStyle(fontSize:13),
    decoration:InputDecoration(hintText:hint,hintStyle:const TextStyle(fontSize:13,color:AppColors.textMuted),
      filled:true,fillColor:AppColors.background,
      border:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:BorderSide.none),
      enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:const BorderSide(color:AppColors.border)),
      focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:const BorderSide(color:AppColors.primary)),
      contentPadding:const EdgeInsets.all(14)),
  );

  Widget _dropdown(String? value,ValueChanged<String?> onChanged) => DropdownButtonFormField<String>(
    value:value, onChanged:onChanged,
    style:const TextStyle(fontSize:13,color:AppColors.textPrimary),
    hint:const Text('Selecione sua turma',style:TextStyle(fontSize:13,color:AppColors.textMuted)),
    decoration:InputDecoration(filled:true,fillColor:AppColors.background,
      border:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:BorderSide.none),
      enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:const BorderSide(color:AppColors.border)),
      focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:const BorderSide(color:AppColors.primary)),
      contentPadding:const EdgeInsets.symmetric(horizontal:14,vertical:14)),
    items:_kTurmas.map((t)=>DropdownMenuItem(value:t,child:Text(t))).toList(),
  );

  Widget _linkField(IconData icon,String label,TextEditingController ctrl,String hint) => Column(
    crossAxisAlignment:CrossAxisAlignment.start,children:[
      Row(children:[
        Icon(icon,size:14,color:AppColors.textSecondary),
        const SizedBox(width:5),
        Text(label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppColors.textPrimary)),
      ]),
      const SizedBox(height:6),
      _textField(ctrl,hint),
    ]);
}

// ─── STATUS CHIP ─────────────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  final _StudentStatus status;
  const _StatusChip(this.status);
  @override
  Widget build(BuildContext context) {
    late Color bg,fg,dot; late String label;
    switch(status){
      case _StudentStatus.approved: bg=AppColors.statusApprovedBg;fg=AppColors.statusApprovedFg;dot=AppColors.statusApprovedDot;label='Aprovado';
      case _StudentStatus.pending:  bg=AppColors.statusPendingBg; fg=AppColors.statusPendingFg; dot=AppColors.statusPendingDot; label='Pendente';
      case _StudentStatus.rejected: bg=AppColors.statusRejectedBg;fg=AppColors.statusRejectedFg;dot=AppColors.statusRejectedDot;label='Reprovado';
    }
    return Container(
      padding:const EdgeInsets.symmetric(horizontal:12,vertical:5),
      decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(20)),
      child:Row(mainAxisSize:MainAxisSize.min,children:[
        Container(width:7,height:7,decoration:BoxDecoration(color:dot,shape:BoxShape.circle)),
        const SizedBox(width:5),
        Text(label,style:TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:fg)),
      ]),
    );
  }
}

// ─── STATS ───────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final int total,pending,approved,rejected; final bool mobile;
  const _StatsRow({required this.total,required this.pending,required this.approved,required this.rejected,required this.mobile});
  @override
  Widget build(BuildContext context) {
    final cards=[
      _SC(value:'$total',  label:'Total de Projetos',icon:Icons.description_outlined,   bg:const Color(0xFFE3F2FD),color:const Color(0xFF1565C0)),
      _SC(value:'$pending',label:'Pendentes',        icon:Icons.access_time_outlined,    bg:const Color(0xFFFFF8E1),color:const Color(0xFFF9A825)),
      _SC(value:'$approved',label:'Aprovados',       icon:Icons.check_circle_outline,    bg:const Color(0xFFE8F5E9),color:AppColors.statusApprovedFg),
      _SC(value:'$rejected',label:'Reprovados',      icon:Icons.cancel_outlined,         bg:const Color(0xFFFFEBEE),color:AppColors.statusRejectedFg),
    ];
    if(mobile) {
      return Column(children:[
        Row(children:[Expanded(child:cards[0]),const SizedBox(width:12),Expanded(child:cards[1])]),
        const SizedBox(height:12),
        Row(children:[Expanded(child:cards[2]),const SizedBox(width:12),Expanded(child:cards[3])]),
      ]);
    }
    return Row(children:cards.asMap().entries.map((e)=>Expanded(child:Padding(
      padding:EdgeInsets.only(right:e.key<cards.length-1?16.0:0.0),child:e.value))).toList());
  }
}
class _SC extends StatelessWidget {
  final String value,label; final IconData icon; final Color bg,color;
  const _SC({required this.value,required this.label,required this.icon,required this.bg,required this.color});
  @override
  Widget build(BuildContext context)=>Container(
    padding:const EdgeInsets.all(20),
    decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppColors.border)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Container(width:40,height:40,decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(10)),child:Icon(icon,color:color,size:20)),
      const SizedBox(height:14),
      Text(value,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w800,color:AppColors.textPrimary)),
      const SizedBox(height:4),
      Text(label,style:const TextStyle(fontSize:12,color:AppColors.textSecondary)),
    ]),
  );
}

// ─── DESKTOP TABLE ────────────────────────────────────────────────────────────
class _DesktopTable extends StatelessWidget {
  final List<_StudentProject> projects;
  final void Function(int) onDelete;
  const _DesktopTable({required this.projects, required this.onDelete});
  @override
  Widget build(BuildContext context)=>Table(
    columnWidths:const{0:FlexColumnWidth(3),1:FlexColumnWidth(1.5),2:FlexColumnWidth(1.5),3:FlexColumnWidth(1.5),4:FlexColumnWidth(2)},
    children:[
      TableRow(decoration:const BoxDecoration(border:Border(bottom:BorderSide(color:AppColors.border))),
        children:['PROJETO','TURMA','SUBMISSAO','STATUS','ACOES'].asMap().entries.map((e)=>Padding(
          padding:const EdgeInsets.only(bottom:12,right:8),
          child:Text(e.value,textAlign:e.key==4?TextAlign.right:TextAlign.left,
              style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:AppColors.textMuted,letterSpacing:0.05)))).toList()),
      ...projects.map((p)=>TableRow(
        decoration:const BoxDecoration(border:Border(top:BorderSide(color:Color(0xFFF3F4F6)))),
        children:[
          Padding(padding:const EdgeInsets.only(top:16,bottom:16,right:8),
            child:Text(p.title,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppColors.textPrimary))),
          Padding(padding:const EdgeInsets.only(top:16,bottom:16,right:8),
            child:Text(p.classGroup,style:const TextStyle(fontSize:13,color:AppColors.textSecondary))),
          Padding(padding:const EdgeInsets.only(top:16,bottom:16,right:8),
            child:Text(p.date,style:const TextStyle(fontSize:13,color:AppColors.textSecondary))),
          Padding(padding:const EdgeInsets.only(top:12,bottom:12,right:8),child:_StatusChip(p.status)),
          Padding(padding:const EdgeInsets.symmetric(vertical:10),
            child:Row(mainAxisAlignment:MainAxisAlignment.end,children:[
              ActionBtn(label:'Detalhes',icon:Icons.remove_red_eye_outlined,borderColor:const Color(0xFFD1D5DB),textColor:AppColors.textSecondary,onPressed:()=>_ProjectDetailsDialog.show(context,project:p)),
              if(p.status==_StudentStatus.rejected)...[const SizedBox(width:8),
                ActionBtn(label:'Editar',icon:Icons.edit_outlined,borderColor:AppColors.primary,textColor:AppColors.primary,onPressed:(){})],
            ])),
        ])),
    ],
  );
}

// ─── MOBILE LIST ─────────────────────────────────────────────────────────────
class _MobileList extends StatelessWidget {
  final List<_StudentProject> projects;
  final void Function(int) onDelete;
  const _MobileList({required this.projects, required this.onDelete});
  @override
  Widget build(BuildContext context)=>Column(children:projects.map((p)=>Padding(
    padding:const EdgeInsets.only(bottom:12),
    child:Container(
      padding:const EdgeInsets.all(14),
      decoration:BoxDecoration(border:Border.all(color:AppColors.border),borderRadius:BorderRadius.circular(12)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[Expanded(child:Text(p.title,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700,color:AppColors.textPrimary))),const SizedBox(width:8),_StatusChip(p.status)]),
        const SizedBox(height:8),
        Row(children:[const Icon(Icons.people_outline,size:13,color:AppColors.textMuted),const SizedBox(width:4),Text(p.classGroup,style:const TextStyle(fontSize:12,color:AppColors.textSecondary)),const SizedBox(width:12),const Icon(Icons.calendar_today_outlined,size:13,color:AppColors.textMuted),const SizedBox(width:4),Text(p.date,style:const TextStyle(fontSize:12,color:AppColors.textSecondary))]),
        const SizedBox(height:12),
        Row(children:[
          Expanded(child:OutlinedButton.icon(onPressed:()=>_ProjectDetailsDialog.show(context,project:p),icon:const Icon(Icons.remove_red_eye_outlined,size:14),label:const Text('Detalhes',style:TextStyle(fontSize:12)),
              style:OutlinedButton.styleFrom(foregroundColor:AppColors.textSecondary,side:const BorderSide(color:AppColors.border),padding:const EdgeInsets.symmetric(vertical:8),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(8))))),
          if(p.status==_StudentStatus.rejected)...[const SizedBox(width:8),
            Expanded(child:OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.edit_outlined,size:14),label:const Text('Editar',style:TextStyle(fontSize:12)),
                style:OutlinedButton.styleFrom(foregroundColor:AppColors.primary,side:const BorderSide(color:AppColors.primary),padding:const EdgeInsets.symmetric(vertical:8),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(8)))))],
        ]),
      ]),
    ),
  )).toList());
}

// ─── PROJECT DETAILS DIALOG ───────────────────────────────────────────────────
class _ProjectDetailsDialog extends StatelessWidget {
  final _StudentProject project;
  const _ProjectDetailsDialog({required this.project});

  static Future<void> show(BuildContext context, {required _StudentProject project}) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => _ProjectDetailsDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = project;
    final w = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(horizontal: w < 600 ? 16 : 80, vertical: 40),
      child: SizedBox(
        width: 640,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('${p.classGroup} · Submetido em ${p.date}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ])),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 20),

                    // Status
                    Row(children: [
                      const Text('Status: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      _StatusChip(p.status),
                    ]),
                    const SizedBox(height: 20),

                    // Descrição
                    if (p.description.isNotEmpty) ...[
                      const Text('Descricao', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 6),
                      Text(p.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
                      const SizedBox(height: 20),
                    ],

                    // Tecnologias
                    if (p.technologies.isNotEmpty) ...[
                      const Text('Tecnologias', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      Wrap(spacing: 8, runSpacing: 8,
                        children: p.technologies.map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F0FF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFD4C8FF)),
                          ),
                          child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF7C3AED))),
                        )).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Links
                    if (p.githubLink != null || p.demoLink != null) ...[
                      Row(children: [
                        if (p.githubLink != null)
                          Expanded(child: _LinkButton(icon: Icons.code, label: 'Repositorio', url: p.githubLink!)),
                        if (p.githubLink != null && p.demoLink != null)
                          const SizedBox(width: 12),
                        if (p.demoLink != null)
                          Expanded(child: _LinkButton(icon: Icons.open_in_new, label: 'Demo Live', url: p.demoLink!)),
                      ]),
                      const SizedBox(height: 20),
                    ],

                    // Justificativa reprovação
                    if (p.status == _StudentStatus.rejected && p.rejectionReason != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.statusRejectedBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF4B8B8)),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Justificativa da Reprovacao',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.statusRejectedFg)),
                          const SizedBox(height: 6),
                          Text(p.rejectionReason!,
                              style: const TextStyle(fontSize: 12, color: AppColors.statusRejectedFg, height: 1.6)),
                        ]),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Fechar', style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const _LinkButton({required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
        const Icon(Icons.open_in_new, size: 14, color: AppColors.textMuted),
      ]),
    );
  }
}

// ─── CONFIRM DELETE DIALOG ────────────────────────────────────────────────────
class _ConfirmDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _ConfirmDeleteDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: SizedBox(
        width: 420,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: AppColors.statusRejectedBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.delete_outline,
                    color: AppColors.statusRejectedFg, size: 28),
              ),
              const SizedBox(height: 16),
              const Text('Excluir Projeto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text(
                'Tem certeza que deseja excluir este projeto? Esta acao nao pode ser desfeita.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancelar', style: TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Excluir', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusRejectedFg,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
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