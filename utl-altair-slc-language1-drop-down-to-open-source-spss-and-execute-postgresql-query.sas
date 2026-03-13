%let pgm=utl-altair-slc-language1-drop-down-to-open-source-spss-and-execute-postgresql-query;

%stop_submission;

Altair slc language1 drop down to open source spss and execute postgresql query

Too long to post on a list, see github
https://github.com/rogerjdeangelis/utl-altair-slc-language1-drop-down-to-open-source-spss-and-execute-postgresql-query

SOAPBOX ON
Unlike the linux version of open source spss(pspp), odbc and native integration of sql(postgresql) is not supported.

I talked with the support team for open source pspp about adding odbc to open source spss,
and they responed that the focus iS ON linux based systems.

This is odd?
"Based on the most recent data from January 2026, the worldwide ratio of Windows desktops to Linux-based desktops
is approximately 17:1. This means for every computer running Linux, there are about 17 running Windows"
.
SOAPBOX OFF


PROBLEM

  I am trying to make sql programmers expert spss programmers, by way of sql.

  Add very powerfull sql processing to the open source spss
  Posgresql has windows extensions.

  I hope to add repos with  drop downs to sql with windows extensions in many languages

  language 1   open source spss
  language 2   open source matlab
  language 3   r
  language 4   python
  language 5   altair odbc sqlite
  language 6   excel
  language 7   perl
  language 8   slc proc sql (the only solution that does not support windows extensions)

Run this query in open source spss

+-------------------------------------------------------------+
| WHATS HAPPENING                                             |
|   1 convert the spss dataset ,.sav, to a csv file           |
|   2 creat a postgresql table fom the csv                    |
|   3 run sql query sumarizing age, weight and output a csv   |
|   4 convert csv to spss ,.sav, dataset                      |
|   5 ... more native spss script using spss dataset          |
| QUERY                                                       |
+-------------------------------------------------------------+
|drop table if exists sqlhav;                                 |
|drop table if exists want;                                   |
|\dt                                                          |
|create                                                       |
| table sqlhav                                                |
|    (NAME TEXT,SEX TEXT,AGE REAL,WEIGHT REAL);               |
|\copy sqlhav from 'd:/csv/have.csv' delimiter ',' csv header;|
|\dt                                                          |
|create                                                       |
|   table want as                                             |
|select                                                       |
|   sex                                                       |
|  ,avg(age)    as avgage                                     |
|  ,avg(weight) as avgwgt                                     |
|from                                                         |
|   sqlhav                                                    |
|group                                                        |
|    by sex                                                   |
|;                                                            |
|\dt                                                          |
|\copy want TO 'd:/csv/wantout.csv' CSV HEADER;               |
+-------------------------------------------------------------+


RELATED REPOS

https://github.com/rogerjdeangelis/utl-connecting-spss-pspp-to-postgresql-sample-problem-compute-mean-weight-by-sex
https://github.com/rogerjdeangelis/utl-creating-spss-tables-from-a-sas-datasets-using-sas-r-and-python
https://github.com/rogerjdeangelis/utl-dropping-down-to-spss-using-the-pspp-free-clone-and-running-a-spss-linear-regression
https://github.com/rogerjdeangelis/utl-identifying-the-html-table-and-exporting-to-spss-then-sas-scraping
https://github.com/rogerjdeangelis/utl-import-dbf-dif-ods-xlsx-spss-json-stata-csv-html-xml-tsv-files-without-sas-access-products
https://github.com/rogerjdeangelis/utl-removing-factors-and-preserving-type-and-length-when-importing-spss-sav-tables
https://github.com/rogerjdeangelis/utl-sas-to-and-from-sqllite-excel-ms-access-spss-stata-using-r-packages-without-sas
https://github.com/rogerjdeangelis/utl-using-open-source-pspp-to-convert-spss-programs-to-sas-or-other-languages
https://github.com/rogerjdeangelis/utl-using-sas-compatible-character-and-numeric-missing-values-in-spss-pspp


PREPARATION

1 Install postgresql (in admin mode)
  https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

  Example
   set password
   super user admon defaults to 'postgres'
   use port 5432
   install only one application pgAgent
   password file


   c:\wpscfg\pgpass.conf
   localhost:5432:template1:postgres:YOURPASSWORD


2 Install PSPP (run as admin?)
  https://ftp.gnu.org/gnu/pspp/pspp-64bit-install-v2-0-0.exe
  simple install

3 save these macros in your autocall file (sasautos)
  drop dows to spss

/*--- save macro in autocall library ---*/
data _null_;
  file "c:/wpsoto/slc_psppbeginx.sas";
  input;
  put _infile_;
cards4;
%macro slc_psppbeginx;
  %utlfkil(c:/temp/ps_pgm.ps);
  %utlfkil(c:/temp/ps_pgm.log);
  data _null_;
    file  "c:/temp/ps_pgm.ps1";
    input;
    put _infile_;
%mend slc_psppbeginx;
;;;;
run;

/*--- save macro in autocall library ---*/
data _null_;
  file "c:/wpsoto/slc_psppendx.sas";
  input;
  put _infile_;
cards4;
%macro slc_psppendx(returnvar=N);
options noxwait noxsync;
filename rut pipe  "c:\PROGRA~1\PSPP\bin\pspp.exe c:/temp/ps_pgm.ps1 >  c:/temp/ps_pgm.log";
run;quit;
  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename ft15f001 clear;
  * use the clipboard to create macro variable;
  %if %upcase(%substr(&returnVar.,1,1)) ne N %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "macro variable &returnVar = " _infile_;
     call symputx("&returnVar.",_infile_,"G");
    run;quit;
  %end;
data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;
data _null_;
  infile "c:/temp/ps_pgm.log";
  input;
  putlog _infile_;
run;quit;
%mend slc_psppendx;
;;;;
run;

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|

Note we are creating an SPSS sav file directly using the SLC.
Even SAS Access cannot create a spss sav file.
SAS access can read spss sav files but not create sav files
*/

libname workx "d:/wpswrkx";      /*--- put in your autoexec ---*/

proc datasets lib=workx kill;
run;

%utlfkil(d:/sav/have.sav);       /* in case you rerun       ---*/

libname sav spss "d:/sav/have.sav";  /*-- read write engine ---*/

data sav.have; /* creates spss d:/sav/have.sav              ---*/
informat
  NAME $8.
  SEX $1.
  AGE 8.
  WEIGHT 8.
;
input
 NAME SEX AGE WEIGHT;
cards4;
Alfred M 14 112.5
Alice F 13 84
Barbara F 13 98
Carol F 14 102.5
Henry M 14 102.5
;;;;
run;quit;

/**************************************************************************************************************************/
/*THE SPSS OUTPUT FILE                                                                                                    */
/*                                                                                                                        */
/*  ASCII Flatfile Ruler & Hex                                                                                            */
/*  utlrulr                                                                                                               */
/*  d:\sav\have.sav                                                                                                       */
/*  d:\txt\delete.txt                                                                                                     */
/*                                                                                                                        */
/*                                                                                                                        */
/*   --- Record Number ---  1   ---  Record Length ---- 100                                                               */
/*                                                                                                                        */
/*  $FL2@(#) SPSS DATA FILE                                         ..........................Y@12 MAR 2                  */
/*  1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95...1                  */
/*  2443422225555244542444422222222222222222222222222222222222222222000000000000000000000000005433244523                  */
/*  46C208390303304141069C5000000000000000000000000000000000000000002000400000000000500000000090120D1202                  */
/*                                                                                                                        */
/*                                                                                                                        */
/*   --- Record Number ---  2   ---  Record Length ---- 100                                                               */
/*                                                                                                                        */
/*  615:51:13                                                                ...........................                  */
/*  1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95...1                  */
/*  3333333332222222222222222222222222222222222222222222222222222222222222222000000000000000000000000000                  */
/*  615A51A130000000000000000000000000000000000000000000000000000000000000000000200080000000000008100810                  */
/*                                                                                                                        */
/*                                                                                                                        */
/*   --- Record Number ---  3   ---  Record Length ---- 100                                                               */
/*                                                                                                                        */
/*  NAME    ........................SEX     ........................AGE     ........................WEIG                  */
/*  1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95...1                  */
/*  4444222200000000000000000000000054522222000000000000000000000000444222220000000000000000000000005444                  */
/*  E1D5000020001000000000000110011035800000200000000000000028502850175000002000000000000000285028507597                  */
/*                                                                                                                        */
/*                                                                                                                        */
/*   --- Record Number ---  4   ---  Record Length ---- 100                                                               */
/*                                                                                                                        */
/*  HT  ................................................................................................                  */
/*  1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95...1                  */
/*  45220000000000000000000000000000D000000000000000EF000000000000000000FFFFFFEFFFFFFFE7FFFFFFEF00000000                  */
/*  84007000300040008000C0000000000002001000100020009D007000400080003000FFFFFFFFFFFFFFFFEFFFFFFF7000B000                  */
/*                                                                                                                        */
/*                                                                                                                        */
/*   --- Record Number ---  5   ---  Record Length ---- 100                                                               */
/*                                                                                                                        */
/*  ....................................................................'...NAME=NAME.SEX=SEX.AGE=AGE.WE                  */
/*  1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95...1                  */
/*  0000000000000000000000000000000000000000000000000000000000000000000020004444344440545354504443444054                  */
/*  4000C0000000800000000000800000000000800010000000800010007000D00010007000E1D5DE1D59358D3589175D175975                  */
/*                                                                                                                        */
/*                                                                                                                        */
/*   --- Record Number ---  6   ---  Record Length ---- 100                                                               */
/*                                                                                                                        */
/*  IGHT=WEIGHT................................................UTF-8........Alfred  M       ......,@....                  */
/*  1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95...1                  */
/*  4445354444500001000000000000000000000000000000010000000000055423E00000004667662242222222000000240000                  */
/*  9784D759784700000008000200010000000000000007000400010005000546D8730000001C625400D0000000000000C00000                  */
/*                                                                                                                        */
/*                                                                                                                        */
/*   --- Record Number ---  7   ---  Record Length ---- 100                                                               */
/*                                                                                                                        */
/*  . \@Alice   F       ......*@......U@Barbara F       ......*@......X@Carol   F       ......,@......Y@                  */
/*  1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...80...85...90...95...1                  */
/*  0254466662224222222200000024000000544676676242222222000000240000085446766222422222220000002400000A54                  */
/*  00C01C93500060000000000000A0000000502122121060000000000000A000000080312FC00060000000000000C000000090                  */
/*                                                                                                                        */
/*                                                                                                                        */
/*   --- Record Number ---  8   ---  Record Length ---- 32                                                                */
/*                                                                                                                        */
/*  Henry   M       ......,@......Y@                                                                                      */
/*  1...5....10...15...20...25...30.                                                                                      */
/*  46677222422222220000002400000A54                                                                                      */
/*  85E29000D0000000000000C000000090                                                                                      */
/**************************************************************************************************************************/

/*                   _     _
(_)_ __  _ __  _   _| |_  | | ___   __ _
| | `_ \| `_ \| | | | __| | |/ _ \ / _` |
| | | | | |_) | |_| | |_  | | (_) | (_| |
|_|_| |_| .__/ \__,_|\__| |_|\___/ \__, |
        |_|                        |___/
*/

1                                          Altair SLC        16:09 Thursday, March 12, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx

NOTE: Library slchelp assigned as follows:
      Engine:        WPD
      Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp

NOTE: Library worksas assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\worksas

NOTE: Library workwpd assigned as follows:
      Engine:        WPD
      Physical Name: d:\workwpd


LOG:  16:09:01
NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.031
      cpu time  : 0.000


NOTE: AUTOEXEC processing completed

1
2         libname workx "d:/wpswrkx";      /*--- put in your autoexec ---*/
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx


Altair SLC

The DATASETS Procedure

         Directory

Libref           WORKX
Engine           SAS7BDAT
Physical Name    d:\wpswrkx

                              Members

            Member    Member
  Number    Name      Type         File Size      Date Last Modified

--------------------------------------------------------------------

       1    WANT      DATA              5120      12MAR2026:16:05:17
3
4         proc datasets lib=workx kill;
5         run;
NOTE: Deleting WORKX.want (type=DATA)
6
7         %utlfkil(d:/sav/have.sav);       /* in case you rerun       ---*/
8
9         libname sav spss "d:/sav/have.sav";  /*-- read write engine ---*/
NOTE: Library sav does not exist
NOTE: Procedure datasets step took :
      real time : 0.055
      cpu time  : 0.046


10
11        data sav.have; /* creates spss d:/sav/have.sav              ---*/
12        informat
13          NAME $8.
14          SEX $1.
15          AGE 8.
16          WEIGHT 8.
17        ;
18        input
19         NAME SEX AGE WEIGHT;
20        cards4;

NOTE: Data set "SAV.have" has 5 observation(s) and 4 variable(s)
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000


21        Alfred M 14 112.5
22        Alice F 13 84
23        Barbara F 13 98
24        Carol F 14 102.5
25        Henry M 14 102.5
26        ;;;;
27        run;quit;
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.157
      cpu time  : 0.093

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utlfkil(c:/temp/output.sql);   *--- sql query              ---*;
%utlfkil(d:/csv/wantout.csv);   *--- postgresql created csv ---*;
%utlfkil(d:/csv/have.csv);      *--- native pspp table      ---*;
%utlfkil(d:/sav/want.sav);      *--- native pspp table      ---*;

proc datasets lib=workx;         *--- final sas dataset      ---*;
  nodetails nolist;
  delete want;
run;quit;

%slc_psppbeginx;
cards4;
DATA LIST FIXED / qry 1-80 (A).

BEGIN DATA
drop table if exists sqlhav;
drop table if exists want;
\dt
create
 table sqlhav
    (NAME TEXT,SEX TEXT,AGE REAL,WEIGHT REAL);
\copy sqlhav from 'd:/csv/have.csv' delimiter ',' csv header;
\dt
create
   table want as
select
   sex
  ,avg(age)    as avgage
  ,avg(weight) as avgwgt
from
   sqlhav
group
    by sex
;
\dt
\copy want TO 'd:/csv/wantout.csv' CSV HEADER;
END DATA.

* DISPLAY THE QUERY
TITLE "PostgreSQL Query Being Executed".
LIST.

SAVE TRANSLATE
  /OUTFILE='c:/temp/output.sql'
  /TYPE=TAB
  /REPLACE.

* CONVERT INPUT d:/sav/have.sav to a csv for postgresql to ingest
GET FILE='d:/sav/have.sav'.
SAVE TRANSLATE
  /OUTFILE='d:/csv/have.csv'
  /TYPE=CSV
  /FIELDNAMES
  /CELLS=VALUES
  /MAP
  /REPLACE.

* execute the query
HOST COMMAND=['set PGPASSFILE=c:\wpscfg\pgpass.conf && psql -U postgres -d template1 -f c:/temp/output.sql -w'].

* prepare outut csv, d:/csv/wantout.csv, from postgresql query above for coversion to spss sav file
GET DATA
  /TYPE=TXT
  /FILE='d:/csv/wantout.csv'
  /DELCASE=LINE
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /VARIABLES=SEX A1 AVEAGE F8.2 AVGWGT F8.2.
EXECUTE.

* create spss sav file
SAVE OUTFILE='d:/sav/want.sav'.

LIST.
;;;;
%slc_psppendx;


libname sav spss "d:/sav/want.sav";

proc contents data=sav.want;
run;

proc prInt data=sav.WANT;
run;quit;

/**************************************************************************************************************************/
/*  Altair SLC                                       |  SPSS                                                              */
/*                                                   |                                                                    */
/* Obs    SEX       AVEAGE       AVGWGT              |                             Data List                              */
/*                                                   |  +-------------------------------------------------------------+   */
/*  1      M         14.00       107.50              |  |                             qry                             |   */
/*  2      F         13.33        94.83              |  +-------------------------------------------------------------+   */
/*                                                   |  |drop table if exists sqlhav;                                 |   */
/* The CONTENTS Procedure                            |  |drop table if exists want;                                   |   */
/*                                                   |  |\dt                                                          |   */
/* Data Set Name        WANT                         |  |create                                                       |   */
/* Member Type          DATA                         |  | table sqlhav                                                |   */
/* Engine               SPSS                         |  |    (NAME TEXT,SEX TEXT,AGE REAL,WEIGHT REAL);               |   */
/* Observations         2                            |  |\copy sqlhav from 'd:/csv/have.csv' delimiter ',' csv header;|   */
/* Variables            3                            |  |\dt                                                          |   */
/* Indexes              0                            |  |create                                                       |   */
/* Observation Length   24                           |  |   table want as                                             |   */
/* Deleted Observations 0                            |  |select                                                       |   */
/* Data Set Type                                     |  |   sex                                                       |   */
/* Label                                             |  |  ,avg(age)    as avgage                                     |   */
/* Compressed           NO                           |  |  ,avg(weight) as avgwgt                                     |   */
/* Sorted               NO                           |  |from                                                         |   */
/* Data Representation  Little endian, IEEE Windows  |  |   sqlhav                                                    |   */
/* Encoding             us-ascii 7-Bit US-ASCII      |  |group                                                        |   */
/*                                                   |  |    by sex                                                   |   */
/*   Engine/Host Dependent Information               |  |;                                                            |   */
/*                                                   |  |\dt                                                          |   */
/* Data Start Position    565                        |  |\copy want TO 'd:/csv/wantout.csv' CSV HEADER;               |   */
/* File Name              d:\sav\want.sav            |  +-------------------------------------------------------------+   */
/*                                                   |                                                                    */
/*   Alphabetic List of Variables and Attributes     |       Data List                                                    */
/*                                                   |  +---+------+------+                                               */
/*  Number  Variable    TypeLen Pos    Format        |  |SEX|AVEAGE|AVGWGT|                                               */
/* __________________________________________        |  +---+------+------+                                               */
/*       2  AVEAGE      Num   8   8    9.2           |  |M  | 14.00|107.50|                                               */
/*       3  AVGWGT      Num   8  16    9.2           |  |F  | 13.33| 94.83|                                               */
/*                                                   |  +---+------+------+                                               */
/**************************************************************************************************************************/

/*                                   _
 _ __  _ __ ___   ___ ___  ___ ___  | | ___   __ _
| `_ \| `__/ _ \ / __/ _ \/ __/ __| | |/ _ \ / _` |
| |_) | | | (_) | (_|  __/\__ \__ \ | | (_) | (_| |
| .__/|_|  \___/ \___\___||___/___/ |_|\___/ \__, |
|_|                                          |___/
*/

1                                          Altair SLC        16:35 Thursday, March 12, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx

NOTE: Library slchelp assigned as follows:
      Engine:        WPD
      Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp

NOTE: Library worksas assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\worksas

NOTE: Library workwpd assigned as follows:
      Engine:        WPD
      Physical Name: d:\workwpd


LOG:  16:35:33
NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.031
      cpu time  : 0.031


NOTE: AUTOEXEC processing completed

1         %utlfkil(c:/temp/output.sql);   *--- sql query              ---*;
2         %utlfkil(d:/csv/wantout.csv);   *--- postgresql created csv ---*;
3         %utlfkil(d:/csv/have.csv);      *--- native pspp table      ---*;
4         %utlfkil(d:/sav/want.sav);      *--- native pspp table      ---*;

Altair SLC

The DATASETS Procedure

         Directory

Libref           WORKX
Engine           SAS7BDAT
Physical Name    d:\wpswrkx
5
6         proc datasets lib=workx;         *--- final sas dataset      ---*;
NOTE: No matching members in directory
7           nodetails nolist;
            ^
ERROR: Statement "nodetails" is not valid
8           delete want;
NOTE: Procedure DATASETS was not executed because of errors detected
9         run;quit;
NOTE: Procedure datasets step took :
      real time : 0.000
      cpu time  : 0.000


10
11        %slc_psppbeginx;
The file c:/temp/ps_pgm.ps does not exist
12        cards4;

NOTE: The file 'c:\temp\ps_pgm.ps1' is:
      Filename='c:\temp\ps_pgm.ps1',
      Owner Name=BUILTIN\Administrators,
      File size (bytes)=0,
      Create Time=13:37:05 Jul 16 2025,
      Last Accessed=16:35:33 Mar 12 2026,
      Last Modified=16:35:33 Mar 12 2026,
      Lrecl=32767, Recfm=V

NOTE: 64 records were written to file 'c:\temp\ps_pgm.ps1'
      The minimum record length was 80
      The maximum record length was 112
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


13        DATA LIST FIXED / qry 1-80 (A).
14
15        BEGIN DATA
16        drop table if exists sqlhav;
17        drop table if exists want;
18        \dt
19        create
20         table sqlhav
21            (NAME TEXT,SEX TEXT,AGE REAL,WEIGHT REAL);
22        \copy sqlhav from 'd:/csv/have.csv' delimiter ',' csv header;
23        \dt
24        create
25           table want as
26        select
27           sex
28          ,avg(age)    as avgage
29          ,avg(weight) as avgwgt
30        from
31           sqlhav
32        group
33            by sex
34        ;
35        \dt
36        \copy want TO 'd:/csv/wantout.csv' CSV HEADER;
37        END DATA.
38
39        * DISPLAY THE QUERY
40        TITLE "PostgreSQL Query Being Executed".
41        LIST.
42
43        SAVE TRANSLATE
44          /OUTFILE='c:/temp/output.sql'
45          /TYPE=TAB
46          /REPLACE.
47
48        * CONVERT INPUT d:/sav/have.sav to a csv for postgresql to ingest
49        GET FILE='d:/sav/have.sav'.
50        SAVE TRANSLATE
51          /OUTFILE='d:/csv/have.csv'
52          /TYPE=CSV
53          /FIELDNAMES
54          /CELLS=VALUES
55          /MAP
56          /REPLACE.
57
58        * execute the query
59        HOST COMMAND=['set PGPASSFILE=c:\wpscfg\pgpass.conf && psql -U postgres -d template1 -f c:/temp/output.sql -w'].
60
61        * prepare outut csv, d:/csv/wantout.csv, from postgresql query above for coversion to spss sav file
62        GET DATA
63          /TYPE=TXT
64          /FILE='d:/csv/wantout.csv'
65          /DELCASE=LINE
66          /DELIMITERS=","
67          /QUALIFIER='"'
68          /ARRANGEMENT=DELIMITED
69          /FIRSTCASE=2
70          /VARIABLES=SEX A1 AVEAGE F8.2 AVGWGT F8.2.
71        EXECUTE.
72
73        * create spss sav file
74        SAVE OUTFILE='d:/sav/want.sav'.
75
76        LIST.
77        ;;;;
78        %slc_psppendx;

NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=c:\PROGRA~1\PSPP\bin\pspp.exe c:/temp/ps_pgm.ps1 >  c:/temp/ps_pgm.log,
      Lrecl=32756, Recfm=V

NOTE: No records were written to file PRINT

NOTE: No records were read from file rut
Stderr output:
psql:c:/temp/output.sql:3: error: Did not find any relations.
NOTE: The data step took :
      real time : 0.302
      cpu time  : 0.015


WARNING: The filename "ft15f001" has not been assigned

NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=c:\PROGRA~1\PSPP\bin\pspp.exe c:/temp/ps_pgm.ps1 >  c:/temp/ps_pgm.log,
      Lrecl=32767, Recfm=V

NOTE: No records were written to file PRINT

NOTE: No records were read from file rut
Stderr output:
psql:c:/temp/output.sql:3: error: Did not find any relations.
NOTE: The data step took :
      real time : 0.236
      cpu time  : 0.015



NOTE: The infile 'c:\temp\ps_pgm.log' is:
      Filename='c:\temp\ps_pgm.log',
      Owner Name=SLC\suzie,
      File size (bytes)=2418,
      Create Time=12:56:22 Feb 17 2026,
      Last Accessed=16:35:33 Mar 12 2026,
      Last Modified=16:35:33 Mar 12 2026,
      Lrecl=32767, Recfm=V

DROP TABLE
DROP TABLE
CREATE TABLE
COPY 5
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | sqlhav | table | postgres
(1 row)

SELECT 2
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | sqlhav | table | postgres
 public | want   | table | postgres
(2 rows)

COPY 2
  Reading 1 record from INLINE.
+--------+------+-------+------+
|Variable|Record|Columns|Format|
+--------+------+-------+------+
|qry     |     1|1-80   |A80   |
+--------+------+-------+------+

                           Data List
+-------------------------------------------------------------+
|                             qry                             |
+-------------------------------------------------------------+
|drop table if exists sqlhav;                                 |
|drop table if exists want;                                   |
|\dt                                                          |
|create                                                       |
| table sqlhav                                                |
|    (NAME TEXT,SEX TEXT,AGE REAL,WEIGHT REAL);               |
|\copy sqlhav from 'd:/csv/have.csv' delimiter ',' csv header;|
|\dt                                                          |
|create                                                       |
|   table want as                                             |
|select                                                       |
|   sex                                                       |
|  ,avg(age)    as avgage                                     |
|  ,avg(weight) as avgwgt                                     |
|from                                                         |
|   sqlhav                                                    |
|group                                                        |
|    by sex                                                   |
|;                                                            |
|\dt                                                          |
|\copy want TO 'd:/csv/wantout.csv' CSV HEADER;               |
+-------------------------------------------------------------+

     Data List
+---+------+------+
|SEX|AVEAGE|AVGWGT|
+---+------+------+
|M  | 14.00|107.50|
|F  | 13.33| 94.83|
+---+------+------+
NOTE: 60 records were read from file 'c:\temp\ps_pgm.log'
      The minimum record length was 0
      The maximum record length was 63
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


79
80
81        libname sav spss "d:/sav/want.sav";
NOTE: Library sav assigned as follows:
      Engine:        SPSS
      Physical Name: d:\sav\want.sav

82
83        proc contents data=sav.want;
84        run;
NOTE: Procedure contents step took :
      real time : 0.047
      cpu time  : 0.046


85
86        proc prInt data=sav.WANT;
87        run;quit;
NOTE: 2 observations were read from "SAV.want"
NOTE: Procedure prInt step took :
      real time : 0.015
      cpu time  : 0.000


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.781
      cpu time  : 0.171

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

