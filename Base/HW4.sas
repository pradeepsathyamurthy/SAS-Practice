DATA WORK.BAYLOR_SURVEY;
	infile 'C:\datasets\baylor-religion-survey-data-2007.txt' lrecl=450 linesize=450;
	input 	ID 1-10
			WEIGHT 11-16
			REGION 17
			RELIG1 18-19
			RELIG2 20-21
			DENOM $ 22-72
			RELGIOUS 73
			ATTEND 74
			HOWLONG 75
			HOWMANY 76
			PERCWHT 77-79
			PERCHISP 80-82
			PERCBLK 83-85
			PERCASN 86-88
			ATTENDO 89-91
			TITHE 92
			HHCONTRB 93-94
			GAMBLING 95
			REVEAL 96
			PORN 97
			PREMARSX 98
			COHABIT 99
			CONTRA 100
			ABORTION 101
			HOMOSEX 102
			DISPWLTH 103
			FRNDWSHP 104
			FRNDDIFF 105
			FRNDDONT 106
			RELIGED 107
			CHOIR 108
			COUNSEL 109
			SOCIAL 110
			WTNSSFR 111
			WTNSSST 112
			COMMPRAY 113
			COMMBIBL 114
			FBPROGRM 115
			OTHERREL 116
			BIBLEBEL 117
			BORNAGN 118
			CHARISMA 119
			CONTMPLT 120
			EVANGEL 121
			FUNDAMEN 122
			MAINLINE 123
			MYSTIC 124
			PENTECST 125
			RELLEFT 126
			RELRIGHT 127
			SEEKER 128
			SPIRIT 129
			THEOCON 130
			THEOLIB 131
			TRADIT 132
			SACREDBK 133
			PRAY 134
			BIBLE 135
			GOD 136
			GODFORCE 137
			GODREMOV 138
			GODWORLD 139
			GODPERS 140
			GODANGER 141
			GODMYSIN 142
			GODINVLV 143
			GODMYAFF 144
			GODMALE 145
			GODABSOL 146
			GODCRIT 147
			GODDIST 148
			GODPRES 149
			GODFTHR 150
			GODFORGV 151
			GODFRND 152
			GODJUST 153
			GODKIND 154
			GODKING 155
			GODLOVNG 156
			GODMTHR 157
			GODPUNSH 158
			GODSEVER 159
			GODWRATH 160
			GODMAJOR 161
			GODSMALL 162
			GODWOES 163
			GODPUNSM 164
			GODRESRV 165
			GODSHOW 166
			GODWAR 167
			GODALLOW 168
			GODCAUSE 169
			GODMIRAC 170
			DEVIL 171
			HEAVEN 172
			HELL 173
			PURGATRY 174
			ARMAGEDD 175
			ANGELS 176
			DEMONS 177
			RAPTURE 178
			GHOST 179
			ET 180
			BIGFOOT 181
			PSYCHIC 182
			GETHEAV 183
			GETAVAMR 184
			GETFRND 185
			GETNGHB 186
			GETFAM 187
			GETCHRST 188
			GETBUDDH 189
			GETMUSLM 190
			GETJEWS 191
			GETNONRL 192
			WITNHEAL 193
			RECHEAL 194
			TONGUES 195
			FELTCALL 196
			HEARDGOD 197
			DREAMREL 198
			GUARDIAN 199
			RELCONV 200
			ONEUNIV 201
			EVILDEVL 202
			EVILMAN 203
			POSSESS 204
			EVILDOUB 205
			HUMANEVL 206
			ROOTEVIL 207
			PARANORM 208
			KEPTFROM 209
			RELPROBS 210
			RELTROUB 211
			RELMISS 212
			BELFAMLY 213
			RELRIDIC 214
			XMASTREE 215
			SANTA 216
			RELFATHR 217
			RELMOTHR 218
			RELSPOUS 219
			RELIG12 220
			ATTEND12 221
			ABRTRAPE 222
			ABRTAFF 223
			DIVNOKID 224
			DIVCHLD 225
			MARIJUAN 226
			PHYSSUIC 227
			STEMCELL 228
			WAR 229
			SEEKJUST 230
			FAITHGOD 231
			CARESICK 232
			TEACHMRL 233
			CONVOTHR 234
			SERVMIL 235
			USEFEWER 236
			CLIMCHNG 237
			EXHAUST 238
			MRLDECAY 239
			ECONCOLL 240
			DESTROY 241
			DEATHPEN 242
			CHRNATN 243
			ENGLISH 244
			DISTRIB 245
			ADVOCHR 246
			REGULATE 247
			SEPARAT 248
			FIGHTTER 249
			PUNISH 250
			GUNLAWS 251
			IMPROVE 252
			DISPREL 253
			PRAYSCHL 254
			SPNDENV 255
			SPNDHLTH 256
			SPNDCRIM 257
			SPNDEDUC 258
			SPNDMIL 259
			SPNDWELF 260
			SPNDSCI 261
			SPNDBRDR 262
			GAYMARR 263
			GAYUNION 264
			CHOOSE 265
			GAYBORN 266
			IRAQWAR 267
			TROOPS 268
			GODSPLAN 269
			RELYSCI 270
			SCISOLUT 271
			GODSGLRY 272
			HUMNEVOL 273
			CREATION 274
			SCIRELIG 275
			SCIHOSTL 276
			POLVIEWS 277
			PARTYID 278-279
			PARTYID2 280-281
			GROUPS 282-283
			PRES08_1 284-285
			PRES08_2 286-287
			VOTEFEM 288
			VOTEMIN 289
			WORKWHT 290
			WORKBLK 291
			WORKHSP 292
			WORKASN 293
			NGHBWHT 294
			NGHBBLK 295
			NGHBHISP 296
			NGHBASN 297
			FRNDWHT 298
			FRNDBLK 299
			FRNDHISP 300
			FRNDASN 301
			CMFRTWHT 302
			CMFRTBLK 303
			CMFRTHSP 304
			CMFRTASN 305
			MOVEDWHT 306
			MOVEDBLK 307
			MOVEDHSP 308
			MOVEDASN 309
			BRINGWHT 310
			BRINGBLK 311
			BRINGHSP 312
			BRINGASN 313
			MARRYWHT 314
			MARRYBLK 315
			MARRYHSP 316
			MARRYASN 317
			DATERACE 318
			TRUSTPPL 319
			TRUSTIMM 320
			TRUSTWHT 321
			TRUSTBLK 322
			TRUSTHSP 323
			TRUSTJEW 324
			TRUSTCHR 325
			MARITAL 326
			HAPPYUND 327
			HAPPYLOV 328
			HAPPYAGR 329
			HAPPYSEX 330
			HAPPYBRD 331
			HAPPYCRE 332
			HAPPYDO 333
			HAPPYFIN 334
			CHILDREN 335-336
			UNDER18 337
			AGEYOUNG 338-339
			CHLDENTR 340
			WHEREKID 341
			KIDSFRND 342
			CORPPUN 343
			PRAISEKD 344
			TIMEOUTS 345
			HOMESCHL 346
			IMPSAME 347
			IMPMARR 348
			IMPSHARE 349
			PARCORP 350
			PARGRND 351
			PARPRAIS 352
			SUITED 353
			SUFFER 354
			WMNCARE 355
			EQCHORES 356
			SALARY 357
			MOREOPP 358
			FEMINIST 359
			GENDER 360
			AGE 361-362
			USCITIZN 363
			RURALURB 364
			HRSWORKD 365-366
			EMPLOYER 367
			JOBTITLE 368-369
			LOCALBUS 370
			NOTWORK 371
			WHITE 372
			BLACK 373
			AMERIND 374
			ASIAN 375
			PACISLND 376
			OTHRRACE 377
			HISPANIC 378
			EDUC 379
			INCOME 380
			FRNDNGHB 381
			FRNDCHAR 382
			FRNDWORK 383
			PYTHRILL 384
			ROMANCE 385
			PURPOSE 386
			PREDICT 387
			MEMORIES 388
			VOLCOMM1 389
			VOLCOMM2 390
			VOLWRSHP 391
			LRNRESP 392
			CRACKDWN 393
			SHOWRESP 394
			EXTROVRT 395
			CRITICAL 396
			TRDEPEND 397
			ANXIOUS 398
			OPENNEW 399
			QUIET 400
			SYMPATH 401
			DISORG 402
			CALM 403
			UNCREAT 404
			RELTRAD 405
			I_AGE 406
			I_EDUC 407
			I_GENDER 408
			I_RELIGION 409
			I_REGION 410
			I_ATTEND 411;
RUN;

*PROC PRINT DATA=WORK.BAYLOR_SURVEY;
*RUN;

* Question-1: Region where the respondent lives (REGION);
DATA WORK.BAYLOR_SURVEY_REGION;
	set WORK.BAYLOR_SURVEY;
	format region_desc $10.;
	if region=1 then region_desc='East';
	else if region=2 then region_desc='Mid-West';
	else if region=3 then region_desc='South';
	else region_desc='West';
	label region_desc='REGION_DESCRIPTION';
	keep region region_desc;
RUN;

PROC SORT DATA=WORK.BAYLOR_SURVEY_REGION;
	by region_desc;
RUN;

PROC FREQ DATA=WORK.BAYLOR_SURVEY_REGION;
	table region_desc;
	title 'Number of People partipated in Survey based on region';
RUN;

PROC FORMAT;
   value Region 1 = 'East' 2 = 'Mid-West' 3 = 'South' 4 = 'West';
RUN;

* Bar chart for BAYLOR_SURVEY_REGION;
PROC SGPLOT DATA=WORK.BAYLOR_SURVEY_REGION;
   vbar region_desc / group = region groupdisplay = cluster;
   format region Region.;
   label BAYLOR_SURVEY_REGION = 'BAR chart for region where the respondent lives';
   title 'REGION (Weighted by FREQUENCY)';
RUN;



* Q58b. If you are married or living as married, please indicate how happy you are with certain aspects of your 
home life and relationship with your partner or spouse: 
The amount of love and affection you receive from you partner/spouse (HAPPYLOV);

DATA WORK.BAYLOR_SURVEY_HAPPYLOV;
	set WORK.BAYLOR_SURVEY;
	format HAPPYLOV_DESC $15.;
	if HAPPYLOV=1 then HAPPYLOV_DESC='Not too happy';
	else if HAPPYLOV=2 then HAPPYLOV_DESC='Pretty happy';
	else if HAPPYLOV=3 then HAPPYLOV_DESC='Very happy';
	else HAPPYLOV_DESC='Missing Data';
	keep HAPPYLOV HAPPYLOV_DESC;
RUN;

PROC SORT DATA=WORK.BAYLOR_SURVEY_HAPPYLOV;
	by HAPPYLOV;

*PROC PRINT DATA=WORK.BAYLOR_SURVEY_HAPPYLOV;
*RUN;

PROC FREQ DATA=WORK.BAYLOR_SURVEY_HAPPYLOV;
	table HAPPYLOV_DESC;
	title 'Satisfaction on Married Life based on love and affection';
RUN;

PROC GCHART data=WORK.BAYLOR_SURVEY_HAPPYLOV;
	pie HAPPYLOV_DESC / other=0
	value=none
	percent=arrow
	slice=arrow
	noheading 
	plabel=(font='Albany AMT/bold' h=1.3 color=depk);
	title "Happiness based on the amount of love and affection in Married life";
RUN;

* Use proc sgplot to plot HAPPYFIN vs. CHILDREN;

DATA WORK.BAYLOR_SURVEY_FAMILY;
	set WORK.BAYLOR_SURVEY;
	format HAPPYFIN_DESC $15.;
	if HAPPYFIN=1 then HAPPYFIN_DESC='Not too happy';
	else if HAPPYFIN=2 then HAPPYFIN_DESC='Pretty happy';
	else if HAPPYFIN=3 then HAPPYFIN_DESC='Very happy';
	else HAPPYFIN_DESC='Missing Data';
	keep HAPPYFIN HAPPYFIN_DESC CHILDREN HRSWORKD;
RUN;

*PROC PRINT DATA=WORK.BAYLOR_SURVEY_FAMILY;
*RUN;

/*PROC TEMPLATE;
   define style styles.mystyle;
      parent=styles.default;
      style graphdata1 from graphdata1 / 
         markersymbol='starfilled' contrastcolor=red;
      style graphdata2 from graphdata2 / 
         markersymbol='trianglefilled' contrastcolor=black;
      style graphdata3 from graphdata3 / 
         markersymbol='squarefilled' contrastcolor=blue;
   end;

ODS HTML STYLE=mystyle;*/

PROC SGPLOT DATA=WORK.BAYLOR_SURVEY_FAMILY;
   title 'Relation between the number of Childres in family vs Hours worked in a week';
   scatter x=CHILDREN y=HRSWORKD / markerattrs=(size=10px);
	   
RUN;

PROC SGPLOT DATA=WORK.BAYLOR_SURVEY_FAMILY;
	title 'Relation between the number of Childres in family vs Hours worked in a week with Regression line';
	reg x=CHILDREN y=HRSWORKD / lineattrs=(color=red thickness=2);
RUN;

QUIT
