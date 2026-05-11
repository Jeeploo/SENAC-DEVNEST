import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/shared_widgets.dart';

// ─── DADOS MOCK ───────────────────────────────────────────────────────────────
const _kBarData  = [('2020',12.0),('2021',25.0),('2022',38.0),('2023',52.0),('2024',68.0)];
const _kLineData = [('Jan',1200.0),('Fev',1900.0),('Mar',2500.0),('Abr',3100.0),('Mai',2800.0),('Jun',3600.0)];
const _kPieData  = [
  ('IoT',0.23,Color(0xFF1565C0)),('Mobile',0.19,Color(0xFF7B1FA2)),
  ('Web',0.28,Color(0xFFD81B60)),('Engenharia',0.18,Color(0xFF2E7D32)),
  ('IA',0.12,Color(0xFFE65100)),
];
const _kTopProjects = [
  ('Sistema de Automacao Residencial',1284,156),
  ('App de Gestao Academica',1156,142),
  ('Plataforma de Aprendizado Adaptativo',982,128),
  ('Prototipo Impressora 3D Sustentavel',874,98),
];
const _kStats = [
  (value:'150',  label:'Projetos Publicados', growth:'+12%', icon:Icons.bar_chart,               bg:Color(0xFFE3F2FD), color:Color(0xFF1565C0)),
  (value:'542',  label:'Alunos Participantes',growth:'+8%',  icon:Icons.people_outline,           bg:Color(0xFFF3E5F5), color:Color(0xFF7B1FA2)),
  (value:'12.4k',label:'Visualizacoes Totais',growth:'+25%', icon:Icons.remove_red_eye_outlined,  bg:Color(0xFFFCE4EC), color:Color(0xFFC2185B)),
  (value:'15',   label:'Projetos Premiados',  growth:'+3',   icon:Icons.emoji_events_outlined,    bg:Color(0xFFFFF3E0), color:Color(0xFFE65100)),
];

// ─── VIEW ─────────────────────────────────────────────────────────────────────
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final hPad   = mobile ? 16.0 : 40.0;
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: mobile ? const AppDrawer() : null,
      body: Column(children: [
        const AppNavBar(),
        Expanded(child: SingleChildScrollView(child: Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 32),
            child: Center(child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Painel de Indicadores',
                    style: TextStyle(fontSize:26,fontWeight:FontWeight.w800,color:AppColors.textPrimary)),
                const SizedBox(height:4),
                const Text('Acompanhe as estatisticas e metricas do SENAC DevNest',
                    style: TextStyle(fontSize:13,color:AppColors.textSecondary)),
                const SizedBox(height:24),
                _StatsRow(mobile: mobile),
                const SizedBox(height:20),
                _ChartRow(mobile: mobile, children: [
                  _ChartCard(title:'Evolucao de Projetos por Ano',   child: const _HoverBarChart()),
                  _ChartCard(title:'Visualizacoes nos Ultimos 6 Meses', child: const _HoverLineChart()),
                ]),
                const SizedBox(height:20),
                _ChartRow(mobile: mobile, children: [
                  _ChartCard(title:'Projetos por Categoria',         child: const _HoverPieChart()),
                  _ChartCard(title:'Projetos Mais Visualizados',     child: _TopProjectsList()),
                ]),
              ]),
            )),
          ),
          const AppFooter(),
        ]))),
      ]),
    );
  }
}

// ─── STATS ────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final bool mobile;
  const _StatsRow({required this.mobile});
  @override
  Widget build(BuildContext context) {
    if (mobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: _kStats.asMap().entries.map((e) => Padding(
          padding: EdgeInsets.only(right: e.key < _kStats.length-1 ? 12 : 0),
          child: SizedBox(width:160, child: _StatCard(s: e.value)),
        )).toList()),
      );
    }
    return Row(children: _kStats.map((s) => Expanded(child: Padding(
      padding: EdgeInsets.only(right: _kStats.indexOf(s)<_kStats.length-1?16:0),
      child: _StatCard(s: s),
    ))).toList());
  }
}

class _StatCard extends StatelessWidget {
  final ({String value,String label,String growth,IconData icon,Color bg,Color color}) s;
  const _StatCard({required this.s});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(14), border:Border.all(color:AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(width:40,height:40, decoration:BoxDecoration(color:s.bg,borderRadius:BorderRadius.circular(10)),
            child:Icon(s.icon,color:s.color,size:20)),
        Text(s.growth, style: const TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:Color(0xFF2E7D32))),
      ]),
      const SizedBox(height:14),
      Text(s.value, style: const TextStyle(fontSize:26,fontWeight:FontWeight.w800,color:AppColors.textPrimary)),
      const SizedBox(height:4),
      Text(s.label, style: const TextStyle(fontSize:11,color:AppColors.textSecondary), maxLines:2, overflow:TextOverflow.ellipsis),
    ]),
  );
}

// ─── CHART LAYOUT ─────────────────────────────────────────────────────────────
class _ChartRow extends StatelessWidget {
  final bool mobile;
  final List<Widget> children;
  const _ChartRow({required this.mobile, required this.children});
  @override
  Widget build(BuildContext context) {
    if (mobile) return Column(children: children.expand((w) => [w, const SizedBox(height:16)]).toList()..removeLast());
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: children.map((w) => Expanded(child: Padding(
      padding: EdgeInsets.only(right: children.indexOf(w)==0?16:0), child: w,
    ))).toList());
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(14), border:Border.all(color:AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize:15,fontWeight:FontWeight.w700,color:AppColors.textPrimary)),
      const SizedBox(height:16),
      child,
    ]),
  );
}

// ─── TOOLTIP HELPER ───────────────────────────────────────────────────────────
void _drawTooltip(Canvas canvas, String text, Offset pos, Size size) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: const TextStyle(fontSize:11,fontWeight:FontWeight.w700,color:Colors.white)),
    textDirection: TextDirection.ltr,
  )..layout();
  const pad = 8.0;
  final w = tp.width + pad*2, h = tp.height + pad*2;
  var dx = pos.dx - w/2;
  var dy = pos.dy - h - 8;
  dx = dx.clamp(0, size.width - w);
  dy = dy.clamp(0, size.height - h);
  final rect = RRect.fromRectAndRadius(Rect.fromLTWH(dx, dy, w, h), const Radius.circular(6));
  canvas.drawRRect(rect, Paint()..color = const Color(0xFF1A2035));
  tp.paint(canvas, Offset(dx+pad, dy+pad));
}

// ─── BAR CHART ────────────────────────────────────────────────────────────────
class _HoverBarChart extends StatefulWidget {
  const _HoverBarChart();
  @override
  State<_HoverBarChart> createState() => _HoverBarChartState();
}
class _HoverBarChartState extends State<_HoverBarChart> {
  int? _hovered;
  static const _h = 260.0;
  static const padL=40.0, padR=10.0, padT=10.0, padB=30.0;

  int? _hitTest(Offset pos, double width) {
    final chartW = width - padL - padR;
    final gap = chartW / _kBarData.length;
    final barW = gap * 0.55;
    for (int i=0; i<_kBarData.length; i++) {
      final x = padL + i*gap + (gap-barW)/2;
      if (pos.dx>=x && pos.dx<=x+barW && pos.dy>=padT && pos.dy<=padT+(_h-padB-padT)) return i;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _h,
    child: LayoutBuilder(builder: (ctx, box) => MouseRegion(
      cursor: _hovered!=null ? SystemMouseCursors.click : MouseCursor.defer,
      onHover:  (e) => setState(()=>_hovered=_hitTest(e.localPosition, box.maxWidth)),
      onExit:   (_) => setState(()=>_hovered=null),
      child: CustomPaint(size:Size(box.maxWidth,_h),
        painter: _BarPainter(data:_kBarData, hovered:_hovered)),
    )),
  );
}

class _BarPainter extends CustomPainter {
  final List<(String,double)> data;
  final int? hovered;
  const _BarPainter({required this.data, required this.hovered});

  @override
  void paint(Canvas canvas, Size size) {
    const padL=40.0,padR=10.0,padT=10.0,padB=30.0;
    final chartW = size.width-padL-padR;
    final chartH = size.height-padB-padT;
    final maxVal = data.map((d)=>d.$2).reduce(max);
    final axisPaint = Paint()..color=AppColors.border..strokeWidth=1;
    const ts = TextStyle(fontSize:10,color:AppColors.textMuted);

    for (int i=0;i<=4;i++) {
      final y = padT+chartH-(i/4)*chartH;
      final val = (maxVal*i/4).round();
      canvas.drawLine(Offset(padL,y),Offset(padL+chartW,y),axisPaint);
      final tp=TextPainter(text:TextSpan(text:'$val',style:ts),textDirection:TextDirection.ltr)..layout();
      tp.paint(canvas,Offset(padL-tp.width-4,y-tp.height/2));
    }

    final gap = chartW/data.length;
    final barW = gap*0.55;
    for (int i=0;i<data.length;i++) {
      final (label,val) = data[i];
      final isH = hovered==i;
      final barH = (val/maxVal)*chartH;
      final x = padL+i*gap+(gap-barW)/2;
      final y = padT+chartH-barH;
      final color = isH ? AppColors.accent : AppColors.primary;
      final paint = Paint()..shader=LinearGradient(
        colors:[color.withValues(alpha:0.7),color],
        begin:Alignment.topCenter,end:Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(x,y,barW,barH));
      canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(x,y,barW,barH),
        topLeft:const Radius.circular(4),topRight:const Radius.circular(4)),paint);
      final tp=TextPainter(text:TextSpan(text:label,style:ts),textDirection:TextDirection.ltr)..layout();
      tp.paint(canvas,Offset(x+barW/2-tp.width/2,padT+chartH+6));
      if (isH) {
        _drawTooltip(canvas,'${val.round()} projetos',Offset(x+barW/2, y), size);
      }
    }
  }
  @override bool shouldRepaint(_BarPainter o) => o.hovered!=hovered;
}

// ─── LINE CHART ───────────────────────────────────────────────────────────────
class _HoverLineChart extends StatefulWidget {
  const _HoverLineChart();
  @override
  State<_HoverLineChart> createState() => _HoverLineChartState();
}
class _HoverLineChartState extends State<_HoverLineChart> {
  int? _hovered;
  static const _h = 260.0;
  static const padL=48.0,padR=10.0;

  int? _hitTest(Offset pos, double width) {
    final chartW = width-padL-padR;
    final relX = pos.dx-padL;
    if (relX<0||relX>chartW) return null;
    final gap = chartW/(_kLineData.length-1);
    return (relX/gap).round().clamp(0,_kLineData.length-1);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _h,
    child: LayoutBuilder(builder: (ctx, box) => MouseRegion(
      cursor: _hovered!=null ? SystemMouseCursors.click : MouseCursor.defer,
      onHover:  (e) => setState(()=>_hovered=_hitTest(e.localPosition,box.maxWidth)),
      onExit:   (_) => setState(()=>_hovered=null),
      child: CustomPaint(size:Size(box.maxWidth,_h),
        painter: _LinePainter(data:_kLineData, hovered:_hovered)),
    )),
  );
}

class _LinePainter extends CustomPainter {
  final List<(String,double)> data;
  final int? hovered;
  const _LinePainter({required this.data, required this.hovered});

  @override
  void paint(Canvas canvas, Size size) {
    const padL=48.0,padR=10.0,padT=10.0,padB=30.0;
    final chartW=size.width-padL-padR, chartH=size.height-padB-padT;
    final maxVal=data.map((d)=>d.$2).reduce(max);
    final axisPaint=Paint()..color=AppColors.border..strokeWidth=1;
    const ts=TextStyle(fontSize:10,color:AppColors.textMuted);

    for (int i=0;i<=4;i++) {
      final y=padT+chartH-(i/4)*chartH;
      final val=((maxVal*i/4)/100).round()*100;
      canvas.drawLine(Offset(padL,y),Offset(padL+chartW,y),axisPaint);
      final tp=TextPainter(text:TextSpan(text:'$val',style:ts),textDirection:TextDirection.ltr)..layout();
      tp.paint(canvas,Offset(padL-tp.width-4,y-tp.height/2));
    }

    final pts=data.asMap().entries.map((e){
      final x=padL+e.key*(chartW/(data.length-1));
      final y=padT+chartH-(e.value.$2/maxVal)*chartH;
      return Offset(x,y);
    }).toList();

    // Área
    final fp=Path()..moveTo(pts.first.dx,padT+chartH);
    for (final p in pts) { fp.lineTo(p.dx,p.dy); }
    fp.lineTo(pts.last.dx,padT+chartH);
    fp.close();
    canvas.drawPath(fp,Paint()..shader=LinearGradient(
      colors:[AppColors.primary.withValues(alpha:0.2),AppColors.primary.withValues(alpha:0)],
      begin:Alignment.topCenter,end:Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(padL,padT,chartW,chartH)));

    // Linha
    final lp=Path()..moveTo(pts.first.dx,pts.first.dy);
    for (int i=1;i<pts.length;i++) {
      final cp1=Offset((pts[i-1].dx+pts[i].dx)/2,pts[i-1].dy);
      final cp2=Offset((pts[i-1].dx+pts[i].dx)/2,pts[i].dy);
      lp.cubicTo(cp1.dx,cp1.dy,cp2.dx,cp2.dy,pts[i].dx,pts[i].dy);
    }
    canvas.drawPath(lp,Paint()..color=AppColors.primary..strokeWidth=2.5..style=PaintingStyle.stroke..strokeCap=StrokeCap.round);

    // Pontos + labels X
    for (int i=0;i<pts.length;i++) {
      final isH=hovered==i;
      canvas.drawCircle(pts[i],isH?7:5,Paint()..color=isH?AppColors.accent:AppColors.primary);
      canvas.drawCircle(pts[i],isH?4:3,Paint()..color=Colors.white);
      final tp=TextPainter(text:TextSpan(text:data[i].$1,style:ts),textDirection:TextDirection.ltr)..layout();
      tp.paint(canvas,Offset(pts[i].dx-tp.width/2,padT+chartH+6));
    }

    // Crosshair + tooltip
    if (hovered!=null) {
      final p=pts[hovered!];
      canvas.drawLine(Offset(p.dx,padT),Offset(p.dx,padT+chartH),
          Paint()..color=AppColors.primary.withValues(alpha:0.3)..strokeWidth=1..style=PaintingStyle.stroke
            ..shader=null);
      final val=data[hovered!].$2.round();
      _drawTooltip(canvas,'${data[hovered!].$1}: $val views',p,size);
    }
  }
  @override bool shouldRepaint(_LinePainter o) => o.hovered!=hovered;
}

// ─── PIE CHART ────────────────────────────────────────────────────────────────
class _HoverPieChart extends StatefulWidget {
  const _HoverPieChart();
  @override
  State<_HoverPieChart> createState() => _HoverPieChartState();
}
class _HoverPieChartState extends State<_HoverPieChart> {
  int? _hovered;
  static const _h = 300.0;

  int? _hitTest(Offset pos, Size size) {
    final cx=size.width/2, cy=size.height/2;
    final r=min(cx,cy)-40;
    final dx=pos.dx-cx, dy=pos.dy-cy;
    final dist=sqrt(dx*dx+dy*dy);
    if (dist>r) return null;
    var angle=atan2(dy,dx)+pi/2;
    if (angle<0) angle+=2*pi;
    double start=0;
    for (int i=0;i<_kPieData.length;i++) {
      final sweep=2*pi*_kPieData[i].$2;
      if (angle>=start&&angle<start+sweep) return i;
      start+=sweep;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _h,
    child: LayoutBuilder(builder: (ctx,box) => MouseRegion(
      cursor: _hovered!=null ? SystemMouseCursors.click : MouseCursor.defer,
      onHover:  (e) => setState(()=>_hovered=_hitTest(e.localPosition,Size(box.maxWidth,_h))),
      onExit:   (_) => setState(()=>_hovered=null),
      child: CustomPaint(size:Size(box.maxWidth,_h),
        painter: _PiePainter(data:_kPieData, hovered:_hovered)),
    )),
  );
}

class _PiePainter extends CustomPainter {
  final List<(String,double,Color)> data;
  final int? hovered;
  const _PiePainter({required this.data, required this.hovered});

  @override
  void paint(Canvas canvas, Size size) {
    final cx=size.width/2, cy=size.height/2;
    final r=min(cx,cy)-40;
    const ts=TextStyle(fontSize:10,fontWeight:FontWeight.w600);

    double startAngle=-pi/2;
    for (int i=0;i<data.length;i++) {
      final (label,pct,color)=data[i];
      final sweep=2*pi*pct;
      final isH=hovered==i;
      final mid=startAngle+sweep/2;
      final offset=isH?8.0:0.0;
      final ox=cos(mid)*offset, oy=sin(mid)*offset;

      // Fatia
      canvas.drawArc(
        Rect.fromCircle(center:Offset(cx+ox,cy+oy),radius:isH?r+6:r),
        startAngle,sweep,true,
        Paint()..color=color..style=PaintingStyle.fill,
      );
      canvas.drawArc(
        Rect.fromCircle(center:Offset(cx+ox,cy+oy),radius:isH?r+6:r),
        startAngle,sweep,true,
        Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=2,
      );

      // Label externo
      final lx2=cx+(r+22)*cos(mid);
      final ly2=cy+(r+22)*sin(mid);
      canvas.drawLine(
        Offset(cx+r*cos(mid),cy+r*sin(mid)),
        Offset(lx2,ly2),
        Paint()..color=color..strokeWidth=1.2,
      );
      final tp=TextPainter(
        text:TextSpan(text:'$label: ${(pct*100).round()}%',style:ts.copyWith(color:color)),
        textDirection:TextDirection.ltr,
      )..layout();
      tp.paint(canvas,Offset(lx2-(cos(mid)>0?0:tp.width), ly2-tp.height/2));

      startAngle+=sweep;
    }

    // Tooltip no hover
    if (hovered!=null) {
      final (label,pct,_)=data[hovered!];
      _drawTooltip(canvas,'$label: ${(pct*100).round()}%',Offset(cx,cy),size);
    }
  }
  @override bool shouldRepaint(_PiePainter o) => o.hovered!=hovered;
}

// ─── TOP PROJECTS ─────────────────────────────────────────────────────────────
class _TopProjectsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: _kTopProjects.asMap().entries.map((e) {
      final (name,views,likes)=e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom:16),
        child: Row(children: [
          Container(
            width:32,height:32,
            decoration:BoxDecoration(color:AppColors.primary.withValues(alpha:0.12),borderRadius:BorderRadius.circular(8)),
            alignment:Alignment.center,
            child:Text('${e.key+1}',style:const TextStyle(fontSize:13,fontWeight:FontWeight.w800,color:AppColors.primary)),
          ),
          const SizedBox(width:12),
          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(name,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppColors.textPrimary),
                maxLines:1,overflow:TextOverflow.ellipsis),
            const SizedBox(height:4),
            Row(children:[
              const Icon(Icons.remove_red_eye_outlined,size:12,color:AppColors.textMuted),
              const SizedBox(width:3),
              Text('$views views',style:const TextStyle(fontSize:11,color:AppColors.textSecondary)),
              const SizedBox(width:10),
              const Icon(Icons.trending_up,size:12,color:AppColors.textMuted),
              const SizedBox(width:3),
              Text('$likes likes',style:const TextStyle(fontSize:11,color:AppColors.textSecondary)),
            ]),
          ])),
        ]),
      );
    }).toList(),
  );
}