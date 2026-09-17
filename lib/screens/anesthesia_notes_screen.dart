// lib/screens/anesthesia_notes_screen.dart
// ============================================================
//  Notes d'Anesthésie — Fiche de surveillance opératoire
//  Stockage local · Export texte · Historique · Recherche
// ============================================================
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';

// ─────────────────────────────────────────────────────────────
//  PALETTE LOCALE — mapped to global design system tokens
// ─────────────────────────────────────────────────────────────
const _kTeal  = AppColors.accent;       // 0xFF2DD4BF — turquoise accent
const _kNavy  = AppColors.primary;      // 0xFF0F4C81 — medical navy blue
const _kBg    = AppColors.background;   // 0xFFF8FAFC — slate background
const _kCard  = AppColors.cardWhite;    // 0xFFFFFFFF — pure white surface
const _kBord  = AppColors.border;       // 0xFFE2E8F0 — slate border

// ─────────────────────────────────────────────────────────────
//  MODÈLES
// ─────────────────────────────────────────────────────────────

class _Drug {
  String name, dose, voie, heure, comment;
  _Drug({this.name='',this.dose='',this.voie='',this.heure='',this.comment=''});
  Map toJson()=>{'n':name,'d':dose,'v':voie,'h':heure,'c':comment};
  factory _Drug.fromJson(Map j)=>_Drug(name:j['n']??'',dose:j['d']??'',
      voie:j['v']??'',heure:j['h']??'',comment:j['c']??'');
  bool get isEmpty=>name.isEmpty&&dose.isEmpty&&voie.isEmpty;
}

class _Vital {
  String heure,ta,fc,spo2,temp,fr,notes;
  _Vital({this.heure='',this.ta='',this.fc='',this.spo2='',
      this.temp='',this.fr='',this.notes=''});
  Map toJson()=>{'h':heure,'ta':ta,'fc':fc,'s':spo2,'t':temp,'fr':fr,'n':notes};
  factory _Vital.fromJson(Map j)=>_Vital(heure:j['h']??'',ta:j['ta']??'',
      fc:j['fc']??'',spo2:j['s']??'',temp:j['t']??'',fr:j['fr']??'',notes:j['n']??'');
}

class AnesthNote {
  final String id;
  DateTime createdAt, updatedAt;
  // Patient
  String nom,age,sexe,taille,poids,dossier,service,
         pathologie,antMed,antAn,allergies,medecin,date,heure;
  // Vitaux actuels (monitoring)
  String taVal,fcVal,spo2Val,tempVal,frVal;
  // Tableau chrono
  List<_Vital> vitaux;
  // Médicaments
  List<_Drug> induction,entretien,inotropes,autres;
  // Événements
  bool evH,evB,evD,evA,evAu;
  String evAuText,evComment;
  // Note générale
  String noteGen;

  AnesthNote({
    required this.id, required this.createdAt, required this.updatedAt,
    this.nom='',this.age='',this.sexe='M',this.taille='',this.poids='',
    this.dossier='',this.service='',this.pathologie='',
    this.antMed='',this.antAn='',this.allergies='',
    this.medecin='',this.date='',this.heure='',
    this.taVal='',this.fcVal='',this.spo2Val='',this.tempVal='',this.frVal='',
    List<_Vital>? vitaux,
    List<_Drug>? induction,List<_Drug>? entretien,
    List<_Drug>? inotropes,List<_Drug>? autres,
    this.evH=false,this.evB=false,this.evD=false,this.evA=false,this.evAu=false,
    this.evAuText='',this.evComment='',this.noteGen='',
  }): vitaux=vitaux??[],induction=induction??[],
      entretien=entretien??[],inotropes=inotropes??[],autres=autres??[];

  String get title=>nom.isNotEmpty?nom:'Note sans nom';
  String get subtitle{
    final d=updatedAt;
    return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}  '
        '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
  }

  Map toJson()=>{
    'id':id,'ca':createdAt.toIso8601String(),'ua':updatedAt.toIso8601String(),
    'nom':nom,'age':age,'sexe':sexe,'taille':taille,'poids':poids,
    'dossier':dossier,'service':service,'patho':pathologie,
    'antMed':antMed,'antAn':antAn,'allergies':allergies,
    'medecin':medecin,'date':date,'heure':heure,
    'taV':taVal,'fcV':fcVal,'spo2V':spo2Val,'tempV':tempVal,'frV':frVal,
    'vitaux':vitaux.map((e)=>e.toJson()).toList(),
    'ind':induction.map((e)=>e.toJson()).toList(),
    'ent':entretien.map((e)=>e.toJson()).toList(),
    'ino':inotropes.map((e)=>e.toJson()).toList(),
    'aut':autres.map((e)=>e.toJson()).toList(),
    'evH':evH,'evB':evB,'evD':evD,'evA':evA,'evAu':evAu,
    'evAuT':evAuText,'evC':evComment,'note':noteGen,
  };

  factory AnesthNote.fromJson(Map j)=>AnesthNote(
    id:j['id']??'',
    createdAt:DateTime.parse(j['ca']),
    updatedAt:DateTime.parse(j['ua']),
    nom:j['nom']??'',age:j['age']??'',sexe:j['sexe']??'M',
    taille:j['taille']??'',poids:j['poids']??'',
    dossier:j['dossier']??'',service:j['service']??'',
    pathologie:j['patho']??'',antMed:j['antMed']??'',
    antAn:j['antAn']??'',allergies:j['allergies']??'',
    medecin:j['medecin']??'',date:j['date']??'',heure:j['heure']??'',
    taVal:j['taV']??'',fcVal:j['fcV']??'',spo2Val:j['spo2V']??'',
    tempVal:j['tempV']??'',frVal:j['frV']??'',
    vitaux:(j['vitaux']as List?)?.map((e)=>_Vital.fromJson(e)).toList()??[],
    induction:(j['ind']as List?)?.map((e)=>_Drug.fromJson(e)).toList()??[],
    entretien:(j['ent']as List?)?.map((e)=>_Drug.fromJson(e)).toList()??[],
    inotropes:(j['ino']as List?)?.map((e)=>_Drug.fromJson(e)).toList()??[],
    autres:(j['aut']as List?)?.map((e)=>_Drug.fromJson(e)).toList()??[],
    evH:j['evH']??false,evB:j['evB']??false,evD:j['evD']??false,
    evA:j['evA']??false,evAu:j['evAu']??false,
    evAuText:j['evAuT']??'',evComment:j['evC']??'',noteGen:j['note']??'',
  );
}

// ─────────────────────────────────────────────────────────────
//  STORAGE
// ─────────────────────────────────────────────────────────────
class _Storage {
  static const _k = 'anesthesia_notes_v2';
  static Future<List<AnesthNote>> load() async {
    final p=await SharedPreferences.getInstance();
    final r=p.getString(_k); if(r==null) return [];
    try{ final l=jsonDecode(r) as List;
      return l.map((e)=>AnesthNote.fromJson(e)).toList()
        ..sort((a,b)=>b.updatedAt.compareTo(a.updatedAt));
    }catch(_){ return []; }
  }
  static Future<void> save(AnesthNote n) async {
    final all=await load();
    final i=all.indexWhere((x)=>x.id==n.id);
    if(i>=0) all[i]=n; else all.insert(0,n);
    final p=await SharedPreferences.getInstance();
    await p.setString(_k,jsonEncode(all.map((x)=>x.toJson()).toList()));
  }
  static Future<void> delete(String id) async {
    final all=await load(); all.removeWhere((x)=>x.id==id);
    final p=await SharedPreferences.getInstance();
    await p.setString(_k,jsonEncode(all.map((x)=>x.toJson()).toList()));
  }
}

// ─────────────────────────────────────────────────────────────
//  ÉCRAN LISTE / HISTORIQUE
// ─────────────────────────────────────────────────────────────
class AnesthesiaNotesScreen extends StatefulWidget {
  const AnesthesiaNotesScreen({super.key});
  @override State<AnesthesiaNotesScreen> createState()=>_ListState();
}

class _ListState extends State<AnesthesiaNotesScreen> {
  List<AnesthNote> _all=[], _shown=[];
  final _q=TextEditingController();
  bool _loading=true;

  @override void initState(){super.initState();_load();_q.addListener(_filter);}
  @override void dispose(){_q.dispose();super.dispose();}

  Future<void> _load() async {
    setState(()=>_loading=true);
    _all=await _Storage.load(); _filter();
    setState(()=>_loading=false);
  }
  void _filter(){
    final q=_q.text.toLowerCase();
    setState(()=>_shown=q.isEmpty?List.from(_all):_all.where((n)=>
      n.nom.toLowerCase().contains(q)||n.dossier.toLowerCase().contains(q)||
      n.date.toLowerCase().contains(q)||n.pathologie.toLowerCase().contains(q)).toList());
  }

  Future<void> _open(AnesthNote n) async {
    await Navigator.push(context,MaterialPageRoute(builder:(_)=>_FormScreen(note:n)));
    _load();
  }
  Future<void> _new() async {
    final now=DateTime.now();
    final n=AnesthNote(
      id:'note_${now.millisecondsSinceEpoch}',createdAt:now,updatedAt:now,
      date:'${now.day.toString().padLeft(2,'0')}/${now.month.toString().padLeft(2,'0')}/${now.year}',
      heure:'${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}',
    );
    await Navigator.push(context,MaterialPageRoute(builder:(_)=>_FormScreen(note:n)));
    _load();
  }
  Future<void> _del(AnesthNote n) async {
    final ok=await showDialog<bool>(context:context,builder:(_)=>AlertDialog(
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
      title:const Text('Supprimer la fiche ?'),
      content:Text('La fiche de "${n.title}" sera supprimée définitivement.'),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Annuler')),
        TextButton(onPressed:()=>Navigator.pop(context,true),
          child:const Text('Supprimer',style:TextStyle(color:Colors.red))),
      ],
    ));
    if(ok==true){await _Storage.delete(n.id);_load();}
  }

  @override Widget build(BuildContext ctx){
    final dark=Theme.of(ctx).brightness==Brightness.dark;
    final bg=dark?AppColors.darkBackground:_kBg;
    final cardC=dark?AppColors.darkCard:_kCard;

    return Scaffold(backgroundColor:bg,body:SafeArea(child:Column(children:[

      // ── Header ──────────────────────────────────────────────
      Container(color:cardC,padding:const EdgeInsets.fromLTRB(18,16,18,12),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[
            Container(padding:const EdgeInsets.all(9),
              decoration:BoxDecoration(
                gradient:const LinearGradient(colors:[AppColors.accent,AppColors.primary],begin:Alignment.topLeft,end:Alignment.bottomRight),
                borderRadius:BorderRadius.circular(13),
                boxShadow:[BoxShadow(color:AppColors.accent,blurRadius:10,offset:const Offset(0,4),spreadRadius:-4)],
              ),
              child:const Icon(Icons.note_alt_rounded,color:Colors.white,size:22)),
            const SizedBox(width:12),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('Notes d\'Anesthésie',style:TextStyle(fontSize:17,fontWeight:FontWeight.w800,
                color:dark?Colors.white:_kNavy)),
              const Text('Fiche de surveillance opératoire',
                style:TextStyle(fontSize:11,color:Colors.grey)),
            ])),
            _GradBtn(label:'+ Nouvelle',onTap:_new),
          ]),
          const SizedBox(height:12),
          // Recherche
          Container(height:40,decoration:BoxDecoration(
            color:dark?AppColors.darkSurface:_kBg,
            borderRadius:BorderRadius.circular(10),
            border:Border.all(color:dark?AppColors.darkBorder:_kBord)),
            child:TextField(controller:_q,
              style:TextStyle(fontSize:13,color:dark?Colors.white:Colors.black87),
              decoration:InputDecoration(
                hintText:'Rechercher par nom, dossier, date…',
                hintStyle:const TextStyle(fontSize:12,color:Colors.grey),
                prefixIcon:const Icon(Icons.search_rounded,size:18,color:Colors.grey),
                suffixIcon:_q.text.isNotEmpty?IconButton(
                  icon:const Icon(Icons.close_rounded,size:16,color:Colors.grey),
                  onPressed:(){_q.clear();_filter();}):null,
                border:InputBorder.none,contentPadding:const EdgeInsets.symmetric(vertical:11),
              ))),
        ])),

      // Compteur
      if(!_loading) Padding(
        padding:const EdgeInsets.fromLTRB(18,10,18,4),
        child:Row(children:[
          Text('${_shown.length} fiche${_shown.length>1?'s':''}',
            style:TextStyle(fontSize:12,color:Colors.grey.shade500,fontWeight:FontWeight.w500)),
        ])),

      // ── Liste ────────────────────────────────────────────────
      Expanded(child:_loading
        ? const Center(child:CircularProgressIndicator(color:_kTeal))
        : _shown.isEmpty
          ? _EmptyState(onNew:_new)
          : ListView.builder(
              padding:const EdgeInsets.fromLTRB(16,4,16,24),
              itemCount:_shown.length,
              itemBuilder:(_,i)=>_NoteCard(
                note:_shown[i],
                onTap:()=>_open(_shown[i]),
                onDelete:()=>_del(_shown[i]),
                dark:dark,
              ))),
    ])));
  }
}

// ─────────────────────────────────────────────────────────────
//  CARTE NOTE (liste)
// ─────────────────────────────────────────────────────────────
class _NoteCard extends StatelessWidget {
  final AnesthNote note;
  final VoidCallback onTap,onDelete;
  final bool dark;
  const _NoteCard({required this.note,required this.onTap,required this.onDelete,required this.dark});

  @override Widget build(BuildContext ctx)=>Padding(
    padding:const EdgeInsets.only(bottom:10),
    child:Material(color:dark?AppColors.darkCard:_kCard,
      borderRadius:BorderRadius.circular(14),
      child:InkWell(borderRadius:BorderRadius.circular(14),onTap:onTap,
        child:Container(
          decoration:BoxDecoration(borderRadius:BorderRadius.circular(14),
            border:Border.all(color:dark?AppColors.darkBorder:_kBord)),
          child:Column(children:[
            // Bande colorée haut
            Container(height:4,decoration:const BoxDecoration(
              gradient:LinearGradient(colors:[_kTeal,_kNavy]),
              borderRadius:BorderRadius.vertical(top:Radius.circular(14)))),
            Padding(padding:const EdgeInsets.fromLTRB(14,10,14,12),
              child:Row(children:[
                // Icône initiales
                Container(width:44,height:44,
                  decoration:BoxDecoration(
                    gradient:LinearGradient(colors:[_kTeal.withOpacity(.15),_kNavy.withOpacity(.12)]),
                    borderRadius:BorderRadius.circular(10)),
                  child:Center(child:Text(
                    note.nom.isNotEmpty?note.nom[0].toUpperCase():'?',
                    style:const TextStyle(fontSize:20,fontWeight:FontWeight.w700,color:_kNavy)))),
                const SizedBox(width:12),
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text(note.title,style:TextStyle(fontSize:14,fontWeight:FontWeight.w700,
                    color:dark?Colors.white:_kNavy),maxLines:1,overflow:TextOverflow.ellipsis),
                  const SizedBox(height:3),
                  if(note.pathologie.isNotEmpty) Text(note.pathologie,
                    style:const TextStyle(fontSize:11,color:_kTeal,fontWeight:FontWeight.w500),
                    maxLines:1,overflow:TextOverflow.ellipsis),
                  const SizedBox(height:2),
                  Row(children:[
                    const Icon(Icons.access_time_rounded,size:11,color:Colors.grey),
                    const SizedBox(width:3),
                    Text(note.subtitle,style:const TextStyle(fontSize:11,color:Colors.grey)),
                    if(note.dossier.isNotEmpty)...[
                      const Text('  ·  ',style:TextStyle(color:Colors.grey,fontSize:11)),
                      const Icon(Icons.folder_outlined,size:11,color:Colors.grey),
                      const SizedBox(width:2),
                      Text(note.dossier,style:const TextStyle(fontSize:11,color:Colors.grey)),
                    ],
                  ]),
                ])),
                // Actions
                Column(mainAxisSize:MainAxisSize.min,children:[
                  _SmallIconBtn(icon:Icons.edit_rounded,color:_kNavy,onTap:onTap),
                  const SizedBox(height:4),
                  _SmallIconBtn(icon:Icons.delete_outline_rounded,color:Colors.red.shade400,onTap:onDelete),
                ]),
              ])),
          ])),
      )));
}

// ─────────────────────────────────────────────────────────────
//  EMPTY STATE
// ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onNew;
  const _EmptyState({required this.onNew});
  @override Widget build(BuildContext ctx)=>Center(child:Padding(
    padding:const EdgeInsets.all(40),
    child:Column(mainAxisSize:MainAxisSize.min,children:[
      Container(padding:const EdgeInsets.all(24),
        decoration:BoxDecoration(
          gradient:LinearGradient(colors:[_kTeal.withOpacity(.1),_kNavy.withOpacity(.08)]),
          shape:BoxShape.circle),
        child:const Icon(Icons.note_alt_outlined,size:52,color:_kTeal)),
      const SizedBox(height:20),
      const Text('Aucune fiche d\'anesthésie',
        style:TextStyle(fontSize:16,fontWeight:FontWeight.w700,color:_kNavy)),
      const SizedBox(height:8),
      const Text('Créez votre première fiche de surveillance\nopératoire en appuyant sur "+ Nouvelle".',
        textAlign:TextAlign.center,style:TextStyle(fontSize:13,color:Colors.grey,height:1.5)),
      const SizedBox(height:24),
      _GradBtn(label:'+ Nouvelle fiche',onTap:onNew),
    ])));
}

// ─────────────────────────────────────────────────────────────
//  ÉCRAN FORMULAIRE (création / édition)
// ─────────────────────────────────────────────────────────────
class _FormScreen extends StatefulWidget {
  final AnesthNote note;
  const _FormScreen({required this.note});
  @override State<_FormScreen> createState()=>_FormState();
}

class _FormState extends State<_FormScreen> with TickerProviderStateMixin {
  late AnesthNote _n;
  late TabController _tab;
  bool _saving=false;
  bool _dirty=false;

  // Controllers patient
  late final TextEditingController _cNom,_cAge,_cTaille,_cPoids,_cDossier,
    _cService,_cPatho,_cAntMed,_cAntAn,_cAllergies,_cMedecin,_cDate,_cHeure;
  // Controllers vitaux actuels
  late final TextEditingController _cTA,_cFC,_cSPO2,_cTemp,_cFR;
  // Événements
  late final TextEditingController _cEvAuText,_cEvComment;
  // Note générale
  late final TextEditingController _cNoteGen;

  @override void initState(){
    super.initState();
    _n=widget.note;
    _tab=TabController(length:5,vsync:this);
    _initControllers();
  }

  void _initControllers(){
    _cNom     =_tc(_n.nom);    _cAge     =_tc(_n.age);
    _cTaille  =_tc(_n.taille); _cPoids   =_tc(_n.poids);
    _cDossier =_tc(_n.dossier);_cService =_tc(_n.service);
    _cPatho   =_tc(_n.pathologie); _cAntMed=_tc(_n.antMed);
    _cAntAn   =_tc(_n.antAn); _cAllergies=_tc(_n.allergies);
    _cMedecin =_tc(_n.medecin); _cDate   =_tc(_n.date);
    _cHeure   =_tc(_n.heure);
    _cTA      =_tc(_n.taVal);  _cFC      =_tc(_n.fcVal);
    _cSPO2    =_tc(_n.spo2Val);_cTemp    =_tc(_n.tempVal);
    _cFR      =_tc(_n.frVal);
    _cEvAuText=_tc(_n.evAuText);_cEvComment=_tc(_n.evComment);
    _cNoteGen =_tc(_n.noteGen);
  }

  TextEditingController _tc(String v){
    final c=TextEditingController(text:v);
    c.addListener(()=>_dirty=true);
    return c;
  }

  @override void dispose(){
    _tab.dispose();
    for(final c in [_cNom,_cAge,_cTaille,_cPoids,_cDossier,_cService,
      _cPatho,_cAntMed,_cAntAn,_cAllergies,_cMedecin,_cDate,_cHeure,
      _cTA,_cFC,_cSPO2,_cTemp,_cFR,_cEvAuText,_cEvComment,_cNoteGen]) c.dispose();
    super.dispose();
  }

  // ── Sync état vers modèle ─────────────────────────────────
  void _syncToModel(){
    _n.nom=_cNom.text; _n.age=_cAge.text; _n.taille=_cTaille.text;
    _n.poids=_cPoids.text; _n.dossier=_cDossier.text; _n.service=_cService.text;
    _n.pathologie=_cPatho.text; _n.antMed=_cAntMed.text; _n.antAn=_cAntAn.text;
    _n.allergies=_cAllergies.text; _n.medecin=_cMedecin.text;
    _n.date=_cDate.text; _n.heure=_cHeure.text;
    _n.taVal=_cTA.text; _n.fcVal=_cFC.text; _n.spo2Val=_cSPO2.text;
    _n.tempVal=_cTemp.text; _n.frVal=_cFR.text;
    _n.evAuText=_cEvAuText.text; _n.evComment=_cEvComment.text;
    _n.noteGen=_cNoteGen.text;
  }

  Future<void> _save({bool quiet=false}) async {
    _syncToModel();
    _n.updatedAt=DateTime.now();
    setState(()=>_saving=true);
    await _Storage.save(_n);
    setState(()=>_saving=false);
    _dirty=false;
    if(!quiet&&mounted){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:const Row(children:[Icon(Icons.check_circle_rounded,color:Colors.white,size:18),
          SizedBox(width:8),Text('Fiche sauvegardée')]),
        backgroundColor:_kTeal,behavior:SnackBarBehavior.floating,
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
        duration:const Duration(seconds:2)));
    }
  }

  Future<bool> _onWillPop() async {
    if(!_dirty) return true;
    final ok=await showDialog<bool>(context:context,builder:(_)=>AlertDialog(
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
      title:const Text('Modifications non sauvegardées'),
      content:const Text('Voulez-vous sauvegarder avant de quitter ?'),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Quitter')),
        TextButton(onPressed:()=>Navigator.pop(context,true),
          child:const Text('Sauvegarder',style:TextStyle(color:_kTeal,fontWeight:FontWeight.w700))),
      ],
    ));
    if(ok==true) await _save(quiet:true);
    return true;
  }

  // ── Export texte ──────────────────────────────────────────
  void _exportText(){
    _syncToModel();
    final sb=StringBuffer();
    sb.writeln('════════════════════════════════════════');
    sb.writeln('   FICHE D\'ANESTHÉSIE — BLOC OPÉRATOIRE');
    sb.writeln('════════════════════════════════════════');
    sb.writeln('Date : ${_n.date}   Heure : ${_n.heure}');
    sb.writeln('Médecin anesthésiste : ${_n.medecin}');
    sb.writeln();
    sb.writeln('── PATIENT ──────────────────────────────');
    sb.writeln('Nom & Prénom    : ${_n.nom}');
    sb.writeln('Âge             : ${_n.age} ans');
    sb.writeln('Sexe            : ${_n.sexe}');
    sb.writeln('Taille          : ${_n.taille} cm');
    sb.writeln('Poids           : ${_n.poids} kg');
    sb.writeln('N° Dossier      : ${_n.dossier}');
    sb.writeln('Service         : ${_n.service}');
    sb.writeln('Pathologie      : ${_n.pathologie}');
    sb.writeln('Antéc. médic.   : ${_n.antMed}');
    sb.writeln('Antéc. anest.   : ${_n.antAn}');
    sb.writeln('Allergies       : ${_n.allergies}');
    sb.writeln();
    sb.writeln('── SIGNES VITAUX (MONITORING) ───────────');
    sb.writeln('TA : ${_n.taVal}  FC : ${_n.fcVal}  SpO2 : ${_n.spo2Val}');
    sb.writeln('Temp : ${_n.tempVal}  FR : ${_n.frVal}');
    if(_n.vitaux.isNotEmpty){
      sb.writeln();
      sb.writeln('Tableau chronologique :');
      sb.writeln('Heure    | TA       | FC  | SpO2 | Temp | FR   | Notes');
      sb.writeln('─────────┼──────────┼─────┼──────┼──────┼──────┼──────────────');
      for(final v in _n.vitaux){
        sb.writeln('${v.heure.padRight(8)} | ${v.ta.padRight(8)} | ${v.fc.padRight(3)} | '
          '${v.spo2.padRight(4)} | ${v.temp.padRight(4)} | ${v.fr.padRight(4)} | ${v.notes}');
      }
    }
    void printDrugs(String label,List<_Drug> drugs){
      if(drugs.isEmpty) return;
      sb.writeln(); sb.writeln('── $label ');
      sb.writeln('Médicament         | Dose    | Voie  | Heure | Commentaire');
      sb.writeln('───────────────────┼─────────┼───────┼───────┼────────────');
      for(final d in drugs){
        if(d.isEmpty) continue;
        sb.writeln('${d.name.padRight(18)}| ${d.dose.padRight(7)} | ${d.voie.padRight(5)} | '
          '${d.heure.padRight(5)} | ${d.comment}');
      }
    }
    printDrugs('MÉDICAMENTS D\'INDUCTION',_n.induction);
    printDrugs('ENTRETIEN ANESTHÉSIQUE',_n.entretien);
    printDrugs('INOTROPES / VASOACTIFS',_n.inotropes);
    printDrugs('AUTRES MÉDICAMENTS',_n.autres);
    sb.writeln();
    sb.writeln('── ÉVÉNEMENTS / COMPLICATIONS ───────────');
    if(_n.evH) sb.writeln('☑ Hypotension');
    if(_n.evB) sb.writeln('☑ Bradycardie');
    if(_n.evD) sb.writeln('☑ Désaturation');
    if(_n.evA) sb.writeln('☑ Réaction allergique');
    if(_n.evAu) sb.writeln('☑ Autre : ${_n.evAuText}');
    if(_n.evComment.isNotEmpty) sb.writeln('Commentaires : ${_n.evComment}');
    sb.writeln();
    sb.writeln('── NOTE GÉNÉRALE ────────────────────────');
    sb.writeln(_n.noteGen);
    sb.writeln();
    sb.writeln('════════════════════════════════════════');

    // Copier dans le presse-papier
    Clipboard.setData(ClipboardData(text:sb.toString()));
    showDialog(context:context,builder:(_)=>AlertDialog(
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
      title:const Row(children:[Icon(Icons.copy_rounded,color:_kTeal),SizedBox(width:8),Text('Fiche exportée')]),
      content:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('La fiche a été copiée dans le presse-papier.',style:TextStyle(fontSize:13)),
        const SizedBox(height:12),
        Container(padding:const EdgeInsets.all(10),
          decoration:BoxDecoration(color:_kBg,borderRadius:BorderRadius.circular(8)),
          child:Text(sb.toString().substring(0,sb.toString().length.clamp(0,300))+'…',
            style:const TextStyle(fontSize:10,fontFamily:'monospace',color:Colors.black54))),
        const SizedBox(height:8),
        const Text('Collez-la dans un email, Word ou WhatsApp.',
          style:TextStyle(fontSize:12,color:Colors.grey)),
      ]),
      actions:[TextButton(onPressed:()=>Navigator.pop(context),
        child:const Text('Fermer',style:TextStyle(color:_kTeal)))],
    ));
  }

  // ── BUILD ─────────────────────────────────────────────────
  @override Widget build(BuildContext ctx){
    final dark=Theme.of(ctx).brightness==Brightness.dark;
    final bg=dark?AppColors.darkBackground:_kBg;
    final cardC=dark?AppColors.darkCard:_kCard;

    return WillPopScope(onWillPop:_onWillPop,child:Scaffold(
      backgroundColor:bg,
      appBar:AppBar(
        backgroundColor:cardC,elevation:0,
        leading:IconButton(icon:const Icon(Icons.arrow_back_rounded),
          color:dark?Colors.white:_kNavy,onPressed:()async{if(await _onWillPop())Navigator.pop(ctx);}),
        title:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(_n.nom.isNotEmpty?_n.nom:'Nouvelle fiche',
            style:TextStyle(fontSize:15,fontWeight:FontWeight.w800,
              color:dark?Colors.white:_kNavy),maxLines:1,overflow:TextOverflow.ellipsis),
          Text('Fiche d\'anesthésie',
            style:TextStyle(fontSize:11,color:dark?Colors.white54:Colors.grey)),
        ]),
        actions:[
          // Export
          IconButton(icon:const Icon(Icons.ios_share_rounded),
            color:_kTeal,tooltip:'Exporter',onPressed:_exportText),
          // Sauvegarder
          Padding(padding:const EdgeInsets.only(right:12),
            child:GestureDetector(onTap:()=>_save(),
              child:Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:7),
                decoration:BoxDecoration(
                  gradient:const LinearGradient(colors:[_kTeal,_kNavy]),
                  borderRadius:BorderRadius.circular(9),
                  boxShadow:[BoxShadow(color:_kTeal.withOpacity(.3),blurRadius:8,offset:const Offset(0,3))]),
                child:_saving
                  ?const SizedBox(width:16,height:16,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2))
                  :const Row(mainAxisSize:MainAxisSize.min,children:[
                    Icon(Icons.save_rounded,color:Colors.white,size:16),
                    SizedBox(width:5),
                    Text('Sauver',style:TextStyle(color:Colors.white,fontSize:12,fontWeight:FontWeight.w700)),
                  ])))),
        ],
        bottom:TabBar(
          controller:_tab,
          isScrollable:true,
          labelColor:AppColors.accent,
          unselectedLabelColor:AppColors.textGrey,
          indicatorColor:AppColors.accent,
          indicatorWeight:3,
          dividerColor:AppColors.divider,
          labelStyle:const TextStyle(fontSize:12,fontWeight:FontWeight.w700),
          unselectedLabelStyle:const TextStyle(fontSize:12),
          tabs:const [
            Tab(icon:Icon(Icons.person_outline_rounded,size:18),text:'Patient'),
            Tab(icon:Icon(Icons.monitor_heart_outlined,size:18),text:'Monitoring'),
            Tab(icon:Icon(Icons.medication_outlined,size:18),text:'Médicaments'),
            Tab(icon:Icon(Icons.warning_amber_rounded,size:18),text:'Événements'),
            Tab(icon:Icon(Icons.notes_rounded,size:18),text:'Note'),
          ]),
      ),
      body:TabBarView(controller:_tab,children:[
        _tabPatient(dark),
        _tabMonitoring(dark),
        _tabMeds(dark),
        _tabEvents(dark),
        _tabNote(dark),
      ]),
    ));
  }

  // ══════════════════════════════════════════════════════════
  //  ONGLET 1 — PATIENT
  // ══════════════════════════════════════════════════════════
  Widget _tabPatient(bool dark)=>SingleChildScrollView(
    padding:const EdgeInsets.all(16),
    child:Column(children:[
      _Section(title:'Identification du Patient',icon:Icons.badge_outlined,dark:dark,
        child:Column(children:[
          _Field(ctrl:_cNom,label:'Nom & Prénom',icon:Icons.person_outline_rounded,dark:dark),
          Row(children:[
            Expanded(child:_Field(ctrl:_cAge,label:'Âge (ans)',icon:Icons.cake_outlined,dark:dark,keyType:TextInputType.number)),
            const SizedBox(width:10),
            Expanded(child:_SexSelector(value:_n.sexe,dark:dark,onChanged:(v)=>setState(()=>_n.sexe=v))),
          ]),
          Row(children:[
            Expanded(child:_Field(ctrl:_cTaille,label:'Taille (cm)',icon:Icons.height_rounded,dark:dark,keyType:TextInputType.number)),
            const SizedBox(width:10),
            Expanded(child:_Field(ctrl:_cPoids,label:'Poids (kg)',icon:Icons.monitor_weight_outlined,dark:dark,keyType:TextInputType.number)),
          ]),
          _Field(ctrl:_cDossier,label:'N° Dossier',icon:Icons.folder_outlined,dark:dark),
          _Field(ctrl:_cService,label:'Service',icon:Icons.local_hospital_outlined,dark:dark),
        ])),
      const SizedBox(height:12),
      _Section(title:'Informations Chirurgicales',icon:Icons.medical_services_outlined,dark:dark,
        child:Column(children:[
          _Field(ctrl:_cPatho,label:'Pathologie / Acte opératoire',icon:Icons.healing_outlined,dark:dark,maxLines:2),
          _Field(ctrl:_cAntMed,label:'Antécédents médicaux',icon:Icons.history_rounded,dark:dark,maxLines:3),
          _Field(ctrl:_cAntAn,label:'Antécédents anesthésiques',icon:Icons.air_outlined,dark:dark,maxLines:2),
          _Field(ctrl:_cAllergies,label:'Allergies connues',icon:Icons.block_outlined,dark:dark,
            color:Colors.red.shade400),
        ])),
      const SizedBox(height:12),
      _Section(title:'Équipe & Planification',icon:Icons.people_outline_rounded,dark:dark,
        child:Column(children:[
          _Field(ctrl:_cMedecin,label:'Médecin anesthésiste',icon:Icons.person_pin_outlined,dark:dark),
          Row(children:[
            Expanded(child:_Field(ctrl:_cDate,label:'Date (JJ/MM/AAAA)',icon:Icons.calendar_today_outlined,dark:dark,keyType:TextInputType.datetime)),
            const SizedBox(width:10),
            Expanded(child:_Field(ctrl:_cHeure,label:'Heure (HH:MM)',icon:Icons.access_time_rounded,dark:dark,keyType:TextInputType.datetime)),
          ]),
        ])),
    ]));

  // ══════════════════════════════════════════════════════════
  //  ONGLET 2 — MONITORING
  // ══════════════════════════════════════════════════════════
  Widget _tabMonitoring(bool dark)=>SingleChildScrollView(
    padding:const EdgeInsets.all(16),
    child:Column(children:[
      // Valeurs actuelles
      _Section(title:'Paramètres Actuels',icon:Icons.monitor_heart_outlined,dark:dark,
        child:Column(children:[
          Row(children:[
            Expanded(child:_VitalBox(label:'TA',unit:'mmHg',ctrl:_cTA,dark:dark,color:Colors.red.shade400)),
            const SizedBox(width:8),
            Expanded(child:_VitalBox(label:'FC',unit:'bpm',ctrl:_cFC,dark:dark,color:Colors.pink.shade400)),
            const SizedBox(width:8),
            Expanded(child:_VitalBox(label:'SpO2',unit:'%',ctrl:_cSPO2,dark:dark,color:_kTeal)),
          ]),
          const SizedBox(height:8),
          Row(children:[
            Expanded(child:_VitalBox(label:'Temp',unit:'°C',ctrl:_cTemp,dark:dark,color:Colors.orange)),
            const SizedBox(width:8),
            Expanded(child:_VitalBox(label:'FR',unit:'/min',ctrl:_cFR,dark:dark,color:Colors.blue)),
            const SizedBox(width:8),
            Expanded(child:Container()),
          ]),
        ])),
      const SizedBox(height:12),
      // Tableau chronologique
      _Section(title:'Tableau Chronologique',icon:Icons.table_chart_outlined,dark:dark,
        child:Column(children:[
          // En-tête tableau
          _TableHeader(dark:dark),
          const SizedBox(height:6),
          // Lignes
          ..._n.vitaux.asMap().entries.map((e)=>_VitalRow(
            v:e.value, idx:e.key, dark:dark,
            onDelete:()=>setState(()=>_n.vitaux.removeAt(e.key)))),
          // Bouton ajouter
          const SizedBox(height:8),
          _AddRowBtn(label:'+ Ajouter une mesure',onTap:(){
            setState((){
              final now=TimeOfDay.now();
              _n.vitaux.add(_Vital(
                heure:'${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}'));
            });
          }),
        ])),
    ]));

  // ══════════════════════════════════════════════════════════
  //  ONGLET 3 — MÉDICAMENTS
  // ══════════════════════════════════════════════════════════
  Widget _tabMeds(bool dark)=>SingleChildScrollView(
    padding:const EdgeInsets.all(16),
    child:Column(children:[
      _DrugSection(title:'Médicaments d\'Induction',icon:Icons.vaccines_outlined,
        color:const Color(0xFF7B1FA2),dark:dark,drugs:_n.induction,
        onAdd:()=>setState(()=>_n.induction.add(_Drug())),
        onDel:(i)=>setState(()=>_n.induction.removeAt(i))),
      const SizedBox(height:12),
      _DrugSection(title:'Entretien Anesthésique',icon:Icons.air_outlined,
        color:const Color(0xFF0288D1),dark:dark,drugs:_n.entretien,
        onAdd:()=>setState(()=>_n.entretien.add(_Drug())),
        onDel:(i)=>setState(()=>_n.entretien.removeAt(i))),
      const SizedBox(height:12),
      _DrugSection(title:'Inotropes / Vasoactifs',icon:Icons.favorite_border_rounded,
        color:Colors.red.shade700,dark:dark,drugs:_n.inotropes,
        onAdd:()=>setState(()=>_n.inotropes.add(_Drug())),
        onDel:(i)=>setState(()=>_n.inotropes.removeAt(i))),
      const SizedBox(height:12),
      _DrugSection(title:'Autres Médicaments',icon:Icons.medication_outlined,
        color:Colors.teal.shade700,dark:dark,drugs:_n.autres,
        onAdd:()=>setState(()=>_n.autres.add(_Drug())),
        onDel:(i)=>setState(()=>_n.autres.removeAt(i))),
    ]));

  // ══════════════════════════════════════════════════════════
  //  ONGLET 4 — ÉVÉNEMENTS
  // ══════════════════════════════════════════════════════════
  Widget _tabEvents(bool dark)=>SingleChildScrollView(
    padding:const EdgeInsets.all(16),
    child:Column(children:[
      _Section(title:'Complications / Événements',icon:Icons.warning_amber_rounded,dark:dark,
        child:Column(children:[
          _EvCheck(label:'Hypotension',value:_n.evH,color:Colors.orange,dark:dark,
            onChanged:(v)=>setState(()=>_n.evH=v)),
          _EvCheck(label:'Bradycardie',value:_n.evB,color:Colors.red,dark:dark,
            onChanged:(v)=>setState(()=>_n.evB=v)),
          _EvCheck(label:'Désaturation',value:_n.evD,color:Colors.blue,dark:dark,
            onChanged:(v)=>setState(()=>_n.evD=v)),
          _EvCheck(label:'Réaction allergique',value:_n.evA,color:Colors.purple,dark:dark,
            onChanged:(v)=>setState(()=>_n.evA=v)),
          _EvCheck(label:'Autre complication',value:_n.evAu,color:Colors.grey.shade700,dark:dark,
            onChanged:(v)=>setState(()=>_n.evAu=v)),
          if(_n.evAu)
            _Field(ctrl:_cEvAuText,label:'Préciser l\'autre complication',dark:dark,
              icon:Icons.edit_outlined),
          const SizedBox(height:8),
          _Field(ctrl:_cEvComment,label:'Commentaires / Détails',dark:dark,
            icon:Icons.comment_outlined,maxLines:4),
        ])),
    ]));

  // ══════════════════════════════════════════════════════════
  //  ONGLET 5 — NOTE GÉNÉRALE
  // ══════════════════════════════════════════════════════════
  Widget _tabNote(bool dark)=>Padding(
    padding:const EdgeInsets.all(16),
    child:_Section(title:'Note Générale',icon:Icons.notes_rounded,dark:dark,
      child:Column(children:[
        Text('Résumé anesthésique · incidents · surveillance postopératoire · recommandations',
          style:TextStyle(fontSize:11,color:dark?Colors.white38:Colors.grey.shade500)),
        const SizedBox(height:10),
        Container(decoration:BoxDecoration(
          color:dark?AppColors.darkSurface:_kBg,
          borderRadius:BorderRadius.circular(10),
          border:Border.all(color:dark?AppColors.darkBorder:_kBord)),
          child:TextField(
            controller:_cNoteGen,
            maxLines:null,
            minLines:14,
            style:TextStyle(
              fontSize:13.5,
              height:1.65,
              color:dark?Colors.white.withOpacity(0.87):Colors.black87),
            decoration:const InputDecoration(
              hintText:'Rédigez ici votre note libre d\'anesthésie…\n\n'
                '• Résumé de l\'intervention\n'
                '• Incidents peropératoires\n'
                '• Consignes postopératoires\n'
                '• Recommandations de surveillance',
              hintStyle:TextStyle(fontSize:12.5,color:Colors.grey,height:1.6),
              border:InputBorder.none,
              contentPadding:EdgeInsets.all(14)))),
        const SizedBox(height:10),
        // Bouton sauvegarder bas de page
        SizedBox(width:double.infinity,
          child:_GradBtn(label:'Sauvegarder la fiche',onTap:()=>_save())),
      ])));
}

// ─────────────────────────────────────────────────────────────
//  WIDGETS RÉUTILISABLES
// ─────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title; final IconData icon;
  final Widget child; final bool dark;
  const _Section({required this.title,required this.icon,required this.child,required this.dark});

  @override Widget build(BuildContext ctx)=>Container(
    decoration:BoxDecoration(
      color:dark?AppColors.darkCard:_kCard,
      borderRadius:BorderRadius.circular(14),
      border:Border.all(color:dark?AppColors.darkBorder:_kBord),
      boxShadow:[BoxShadow(color:Colors.black.withOpacity(.04),blurRadius:8,offset:const Offset(0,2))],
    ),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      // Titre section
      Container(padding:const EdgeInsets.fromLTRB(14,12,14,10),
        decoration:BoxDecoration(
          color:dark?_kNavy.withOpacity(.3):_kTeal.withOpacity(.07),
          borderRadius:const BorderRadius.vertical(top:Radius.circular(14))),
        child:Row(children:[
          Icon(icon,size:16,color:_kTeal),const SizedBox(width:8),
          Text(title,style:TextStyle(fontSize:13,fontWeight:FontWeight.w700,
            color:dark?Colors.white:_kNavy)),
        ])),
      Padding(padding:const EdgeInsets.all(12),child:child),
    ]));
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData? icon;
  final bool dark;
  final int maxLines;
  final TextInputType keyType;
  final Color? color;
  const _Field({required this.ctrl,required this.label,this.icon,required this.dark,
    this.maxLines=1,this.keyType=TextInputType.text,this.color});

  @override Widget build(BuildContext ctx)=>Padding(
    padding:const EdgeInsets.only(bottom:10),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(label,style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,
        color:color??(dark?Colors.white70:_kNavy.withOpacity(.7)))),
      const SizedBox(height:5),
      Container(decoration:BoxDecoration(
        color:dark?AppColors.darkSurface:_kBg,
        borderRadius:BorderRadius.circular(9),
        border:Border.all(color:dark?AppColors.darkBorder:_kBord)),
        child:TextField(controller:ctrl,maxLines:maxLines,keyboardType:keyType,
          style:TextStyle(fontSize:13,color:dark?Colors.white:Colors.black87),
          decoration:InputDecoration(
            prefixIcon:icon!=null?Icon(icon,size:17,color:color??_kTeal):null,
            border:InputBorder.none,
            contentPadding:EdgeInsets.symmetric(
              horizontal:icon!=null?4:12,vertical:maxLines>1?10:0)))),
    ]));
}

class _SexSelector extends StatelessWidget {
  final String value; final bool dark;
  final ValueChanged<String> onChanged;
  const _SexSelector({required this.value,required this.dark,required this.onChanged});
  @override Widget build(BuildContext ctx)=>Padding(
    padding:const EdgeInsets.only(bottom:10),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('Sexe',style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,
        color:dark?Colors.white70:AppColors.primary.withOpacity(.7))),
      const SizedBox(height:5),
      Row(children:[
        _SexBtn(label:'M',active:value=='M',dark:dark,onTap:()=>onChanged('M')),
        const SizedBox(width:8),
        _SexBtn(label:'F',active:value=='F',dark:dark,onTap:()=>onChanged('F')),
      ]),
    ]));
}
class _SexBtn extends StatelessWidget {
  final String label; final bool active,dark; final VoidCallback onTap;
  const _SexBtn({required this.label,required this.active,required this.dark,required this.onTap});
  @override Widget build(BuildContext ctx)=>GestureDetector(onTap:onTap,
    child:Container(padding:const EdgeInsets.symmetric(horizontal:20,vertical:9),
      decoration:BoxDecoration(
        color:active?_kTeal:(dark?AppColors.darkSurface:_kBg),
        borderRadius:BorderRadius.circular(9),
        border:Border.all(color:active?_kTeal:(dark?AppColors.darkBorder:_kBord))),
      child:Text(label,style:TextStyle(fontSize:13,fontWeight:FontWeight.w700,
        color:active?Colors.white:(dark?Colors.white60:Colors.grey)))));
}

class _VitalBox extends StatelessWidget {
  final String label,unit; final TextEditingController ctrl;
  final bool dark; final Color color;
  const _VitalBox({required this.label,required this.unit,required this.ctrl,
    required this.dark,required this.color});
  @override Widget build(BuildContext ctx)=>Container(
    padding:const EdgeInsets.all(10),
    decoration:BoxDecoration(
      color:dark?AppColors.darkSurface:color.withOpacity(.07),
      borderRadius:BorderRadius.circular(10),
      border:Border.all(color:color.withOpacity(.3))),
    child:Column(children:[
      Text(label,style:TextStyle(fontSize:10,fontWeight:FontWeight.w700,color:color)),
      const SizedBox(height:4),
      TextField(controller:ctrl,textAlign:TextAlign.center,
        keyboardType:TextInputType.text,
        style:TextStyle(fontSize:16,fontWeight:FontWeight.w700,
          color:dark?Colors.white:Colors.black87),
        decoration:InputDecoration(
          hintText:'—',hintStyle:TextStyle(color:color.withOpacity(.4),fontSize:16),
          border:InputBorder.none,isDense:true,contentPadding:EdgeInsets.zero)),
      Text(unit,style:TextStyle(fontSize:9,color:color.withOpacity(.7))),
    ]));
}

class _TableHeader extends StatelessWidget {
  final bool dark;
  const _TableHeader({required this.dark});
  @override Widget build(BuildContext ctx)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:6,vertical:6),
    decoration:BoxDecoration(
      color:AppColors.primary.withOpacity(.07),borderRadius:BorderRadius.circular(6)),
    child:Row(children:[
      _Th('Heure',flex:2),_Th('TA',flex:2),_Th('FC',flex:1),
      _Th('SpO2',flex:2),_Th('Temp',flex:2),_Th('FR',flex:1),_Th('Notes',flex:3),
      const SizedBox(width:28),
    ]));
}
class _Th extends StatelessWidget {
  final String t; final int flex;
  const _Th(this.t,{required this.flex});
  @override Widget build(BuildContext ctx)=>Expanded(flex:flex,child:Text(t,
    textAlign:TextAlign.center,style:const TextStyle(fontSize:9,fontWeight:FontWeight.w700,color:AppColors.primary)));
}

class _VitalRow extends StatefulWidget {
  final _Vital v; final int idx; final bool dark; final VoidCallback onDelete;
  const _VitalRow({required this.v,required this.idx,required this.dark,required this.onDelete});
  @override State<_VitalRow> createState()=>_VitalRowState();
}
class _VitalRowState extends State<_VitalRow>{
  late final List<TextEditingController> _cs;
  @override void initState(){
    super.initState();
    final v=widget.v;
    _cs=[v.heure,v.ta,v.fc,v.spo2,v.temp,v.fr,v.notes]
      .map((s){final c=TextEditingController(text:s);
        c.addListener((){
          v.heure=_cs[0].text;v.ta=_cs[1].text;v.fc=_cs[2].text;
          v.spo2=_cs[3].text;v.temp=_cs[4].text;v.fr=_cs[5].text;v.notes=_cs[6].text;
        });return c;}).toList();
  }
  @override void dispose(){for(final c in _cs)c.dispose();super.dispose();}
  @override Widget build(BuildContext ctx){
    final bg=widget.idx%2==0?(widget.dark?Colors.white.withOpacity(.03):Colors.white)
        :(widget.dark?Colors.white.withOpacity(.01):_kBg);
    return Container(margin:const EdgeInsets.only(bottom:2),
      padding:const EdgeInsets.symmetric(horizontal:4,vertical:3),
      decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(6)),
      child:Row(children:[
        _TC(_cs[0],flex:2,dark:widget.dark),_TC(_cs[1],flex:2,dark:widget.dark),
        _TC(_cs[2],flex:1,dark:widget.dark),_TC(_cs[3],flex:2,dark:widget.dark),
        _TC(_cs[4],flex:2,dark:widget.dark),_TC(_cs[5],flex:1,dark:widget.dark),
        _TC(_cs[6],flex:3,dark:widget.dark),
        IconButton(icon:const Icon(Icons.remove_circle_outline_rounded,
          size:16,color:Colors.red),onPressed:widget.onDelete,
          padding:EdgeInsets.zero,constraints:const BoxConstraints()),
      ]));
  }
}
class _TC extends StatelessWidget {
  final TextEditingController c; final int flex; final bool dark;
  const _TC(this.c,{required this.flex,required this.dark});
  @override Widget build(BuildContext ctx)=>Expanded(flex:flex,child:TextField(controller:c,
    textAlign:TextAlign.center,
    style:TextStyle(fontSize:11,color:dark?Colors.white70:Colors.black87),
    decoration:InputDecoration(border:InputBorder.none,isDense:true,
      contentPadding:const EdgeInsets.symmetric(horizontal:2,vertical:4),
      hintText:'—',hintStyle:TextStyle(color:Colors.grey.shade400,fontSize:11))));
}

class _DrugSection extends StatelessWidget {
  final String title; final IconData icon; final Color color;
  final bool dark; final List<_Drug> drugs;
  final VoidCallback onAdd; final void Function(int) onDel;
  const _DrugSection({required this.title,required this.icon,required this.color,
    required this.dark,required this.drugs,required this.onAdd,required this.onDel});

  @override Widget build(BuildContext ctx)=>_Section(title:title,icon:icon,dark:dark,
    child:Column(children:[
      // Header colonnes
      if(drugs.isNotEmpty) Padding(padding:const EdgeInsets.only(bottom:6),
        child:Row(children:[
          _Th2('Médicament',flex:4),_Th2('Dose',flex:2),
          _Th2('Voie',flex:2),_Th2('Heure',flex:2),_Th2('Commentaire',flex:4),
          const SizedBox(width:28),
        ])),
      ...drugs.asMap().entries.map((e)=>_DrugRow(
        d:e.value,idx:e.key,color:color,dark:dark,onDel:()=>onDel(e.key))),
      const SizedBox(height:6),
      _AddRowBtn(label:'+ Ajouter un médicament',color:color,onTap:onAdd),
    ]));
}
class _Th2 extends StatelessWidget {
  final String t; final int flex;
  const _Th2(this.t,{required this.flex});
  @override Widget build(BuildContext ctx)=>Expanded(flex:flex,child:Text(t,
    style:const TextStyle(fontSize:9,fontWeight:FontWeight.w600,color:Colors.grey)));
}

class _DrugRow extends StatefulWidget {
  final _Drug d; final int idx; final Color color; final bool dark; final VoidCallback onDel;
  const _DrugRow({required this.d,required this.idx,required this.color,required this.dark,required this.onDel});
  @override State<_DrugRow> createState()=>_DrugRowState();
}
class _DrugRowState extends State<_DrugRow>{
  late final List<TextEditingController> _cs;
  @override void initState(){
    super.initState();
    final d=widget.d;
    _cs=[d.name,d.dose,d.voie,d.heure,d.comment]
      .map((s){final c=TextEditingController(text:s);
        c.addListener((){d.name=_cs[0].text;d.dose=_cs[1].text;
          d.voie=_cs[2].text;d.heure=_cs[3].text;d.comment=_cs[4].text;});
        return c;}).toList();
  }
  @override void dispose(){for(final c in _cs)c.dispose();super.dispose();}
  @override Widget build(BuildContext ctx){
    final bg=widget.idx%2==0?(widget.dark?Colors.white.withOpacity(.03):Colors.white)
        :(widget.dark?Colors.white.withOpacity(.01):_kBg);
    return Container(margin:const EdgeInsets.only(bottom:2),
      padding:const EdgeInsets.symmetric(horizontal:2,vertical:3),
      decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(6),
        border:Border(left:BorderSide(color:widget.color.withOpacity(.4),width:3))),
      child:Row(children:[
        _TC(_cs[0],flex:4,dark:widget.dark),_TC(_cs[1],flex:2,dark:widget.dark),
        _TC(_cs[2],flex:2,dark:widget.dark),_TC(_cs[3],flex:2,dark:widget.dark),
        _TC(_cs[4],flex:4,dark:widget.dark),
        IconButton(icon:const Icon(Icons.remove_circle_outline_rounded,
          size:16,color:Colors.red),onPressed:widget.onDel,
          padding:EdgeInsets.zero,constraints:const BoxConstraints()),
      ]));
  }
}

class _EvCheck extends StatelessWidget {
  final String label; final bool value,dark; final Color color;
  final ValueChanged<bool> onChanged;
  const _EvCheck({required this.label,required this.value,required this.dark,
    required this.color,required this.onChanged});
  @override Widget build(BuildContext ctx)=>GestureDetector(
    onTap:()=>onChanged(!value),
    child:Container(margin:const EdgeInsets.only(bottom:8),
      padding:const EdgeInsets.symmetric(horizontal:12,vertical:10),
      decoration:BoxDecoration(
        color:value?color.withOpacity(.1):(dark?AppColors.darkSurface:_kBg),
        borderRadius:BorderRadius.circular(10),
        border:Border.all(color:value?color.withOpacity(.5):(dark?AppColors.darkBorder:_kBord))),
      child:Row(children:[
        AnimatedContainer(duration:const Duration(milliseconds:180),
          width:20,height:20,
          decoration:BoxDecoration(
            color:value?color:Colors.transparent,
            borderRadius:BorderRadius.circular(5),
            border:Border.all(color:value?color:(dark?Colors.white38:Colors.grey.shade400),width:1.5)),
          child:value?const Icon(Icons.check_rounded,size:14,color:Colors.white):null),
        const SizedBox(width:10),
        Text(label,style:TextStyle(fontSize:13,fontWeight:FontWeight.w500,
          color:value?color:(dark?Colors.white70:Colors.black87))),
      ])));
}

class _AddRowBtn extends StatelessWidget {
  final String label; final VoidCallback onTap; final Color? color;
  const _AddRowBtn({required this.label,required this.onTap,this.color});
  @override Widget build(BuildContext ctx)=>GestureDetector(onTap:onTap,
    child:Container(padding:const EdgeInsets.symmetric(vertical:8),
      decoration:BoxDecoration(
        color:(color??_kTeal).withOpacity(.07),
        borderRadius:BorderRadius.circular(8),
        border:Border.all(color:(color??_kTeal).withOpacity(.25),style:BorderStyle.solid)),
      child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
        Icon(Icons.add_circle_outline_rounded,size:16,color:color??_kTeal),
        const SizedBox(width:6),
        Text(label,style:TextStyle(fontSize:12,fontWeight:FontWeight.w600,
          color:color??_kTeal)),
      ])));
}

class _GradBtn extends StatelessWidget {
  final String label; final VoidCallback onTap;
  const _GradBtn({required this.label,required this.onTap});
  @override Widget build(BuildContext ctx)=>GestureDetector(onTap:onTap,
    child:Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:10),
      decoration:BoxDecoration(
        gradient:const LinearGradient(colors:[AppColors.accent,AppColors.primary]),
        borderRadius:BorderRadius.circular(10),
        boxShadow:[BoxShadow(color:AppColors.accent,blurRadius:8,offset:const Offset(0,3),spreadRadius:-3)]),
      child:Text(label,style:const TextStyle(color:Colors.white,fontSize:12,fontWeight:FontWeight.w700))));
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon; final Color color; final VoidCallback onTap;
  const _SmallIconBtn({required this.icon,required this.color,required this.onTap});
  @override Widget build(BuildContext ctx)=>GestureDetector(onTap:onTap,
    child:Container(padding:const EdgeInsets.all(6),
      decoration:BoxDecoration(color:color.withOpacity(.1),
        borderRadius:BorderRadius.circular(7)),
      child:Icon(icon,size:15,color:color)));
}