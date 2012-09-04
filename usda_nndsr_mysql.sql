-- =========================================================================================================
-- USDA National Nutrient Database for Standard Reference, Release 24 (http://www.ars.usda.gov/nutrientdata)
-- This file was generated by http://github/m5n/usda-nutrient-database-sql-port
-- Run this SQL with an account that has admin priviledges, e.g.: mysql -v -u root < file.sql
-- =========================================================================================================

drop database if exists food;
create database food;
use food;

grant usage on *.* to 'food'@'localhost';   -- Creates user if it does not yet exist.
drop user 'food'@'localhost';
create user 'food'@'localhost' identified by 'food';
grant all on food.* to 'food'@'localhost' identified by 'food';

-- File FOOD_DES.txt: Food Description
create table FOOD_DES (
    -- 5-digit Nutrient Databank number that uniquely identifies a food item. If this field is defined as numeric, the leading zero will be lost.
    NDB_No varchar(5) not null,

    -- 4-digit code indicating food group to which a food item belongs.
    FdGrp_Cd varchar(4) not null,

    -- 200-character description of food item.
    Long_Desc varchar(200) not null,

    -- 60-character abbreviated description of food item. Generated from the 200-character description using abbreviations in Appendix A. If short description is longer than 60 characters, additional abbreviations are made.
    Shrt_Desc varchar(60) not null,

    -- Other names commonly used to describe a food, including local or regional names for various foods, for example, "soda" or "pop" for "carbonated beverages."
    ComName varchar(100) null,

    -- Indicates the company that manufactured the product, when appropriate.
    ManufacName varchar(65) null,

    -- Indicates if the food item is used in the USDA Food and Nutrient Database for Dietary Studies (FNDDS) and thus has a complete nutrient profile for the 65 FNDDS nutrients.
    Survey varchar(1) null,

    -- Description of inedible parts of a food item (refuse), such as seeds or bone.
    Ref_desc varchar(135) null,

    -- Percentage of refuse.
    Refuse tinyint(2) unsigned null,

    -- Scientific name of the food item. Given for the least processed form of the food (usually raw), if applicable.
    SciName varchar(65) null,

    -- Factor for converting nitrogen to protein (see p. 10).
    N_Factor dec(4, 2) unsigned null,

    -- Factor for calculating calories from protein (see p. 11).
    Pro_Factor dec(4, 2) unsigned null,

    -- Factor for calculating calories from fat (see p. 11).
    Fat_Factor dec(4, 2) unsigned null,

    -- Factor for calculating calories from carbohydrate (see p. 11).
    CHO_Factor dec(4, 2) unsigned null
);
alter table FOOD_DES add primary key (NDB_No);

-- File NUT_DATA.txt: Nutrient Data
create table NUT_DATA (
    -- 5-digit Nutrient Databank number.
    NDB_No varchar(5) not null,

    -- Unique 3-digit identifier code for a nutrient .
    Nutr_No varchar(3) not null,

    -- Amount in 100 grams, edible portion (Nutrient values have been rounded to a specified number of decimal places for each nutrient. Number of decimal places is listed in the Nutrient Definition file.).
    Nutr_Val dec(10, 3) unsigned not null,

    -- Number of data points (previously called Sample_Ct) is the number of analyses used to calculate the nutrient value. If the number of data points is 0, the value was calculated or imputed.
    Num_Data_Pts mediumint(5) unsigned not null,

    -- Standard error of the mean. Null if cannot be calculated. The standard error is also not given if the number of data points is less than three.
    Std_Error dec(8, 3) unsigned null,

    -- Code indicating type of data.
    Src_Cd varchar(2) not null,

    -- Data Derivation Code giving specific information on how the value is determined
    Deriv_Cd varchar(4) null,

    -- NDB number of the item used to impute a missing value. Populated only for items added or updated starting with SR14.
    Ref_NDB_No varchar(5) null,

    -- Indicates a vitamin or mineral added for fortification or enrichment. This field is populated for ready-to-eat breakfast cereals in food group 8.
    Add_Nutr_Mark varchar(1) null,

    -- Number of studies.
    Num_Studies tinyint(2) unsigned null,

    -- Minimum value.
    Min dec(10, 3) unsigned null,

    -- Maximum value.
    Max dec(10, 3) unsigned null,

    -- Degrees of freedom.
    DF tinyint(2) unsigned null,

    -- Lower 95% error bound.
    Low_EB dec(10, 3) unsigned null,

    -- Upper 95% error bound.
    Up_EB dec(10, 3) unsigned null,

    -- Statistical comments. See definitions below.
    Stat_cmt varchar(10) null,

    -- Indicates when a value was either added to the database or last modified.
    AddMod_Date varchar(10) null,

    -- Confidence Code indicating data quality, based on evaluation of sample plan, sample handling, analytical method, analytical quality control, and number of samples analyzed. Not included in this release, but is planned for future releases.
    CC varchar(1) null
);
alter table NUT_DATA add primary key (NDB_No, Nutr_No);

-- File WEIGHT.txt: Weight
create table WEIGHT (
    -- 5-digit Nutrient Databank number.
    NDB_No varchar(5) not null,

    -- Sequence number.
    Seq varchar(2) not null,

    -- Unit modifier (for example, 1 in "1 cup").
    Amount dec(5, 3) unsigned not null,

    -- Description (for example, cup, diced, and 1-inch pieces).
    Msre_Desc varchar(80) not null,

    -- Gram weight.
    Gm_Wgt dec(7, 1) unsigned not null,

    -- Number of data points.
    Num_Data_Pts smallint(3) unsigned null,

    -- Standard deviation.
    Std_Dev dec(7, 3) unsigned null
);
alter table WEIGHT add primary key (NDB_No, Seq);

-- File FOOTNOTE.txt: Footnote
create table FOOTNOTE (
    -- 5-digit Nutrient Databank number.
    NDB_No varchar(5) not null,

    -- Sequence number. If a given footnote applies to more than one nutrient number, the same footnote number is used. As a result, this file cannot be indexed.
    Footnt_No varchar(4) not null,

    -- Type of footnote: D = footnote adding information to the food description; M = footnote adding information to measure description; N = footnote providing additional information on a nutrient value. If the Footnt_typ = N, the Nutr_No will also be filled in.
    Footnt_Typ varchar(1) not null,

    -- Unique 3-digit identifier code for a nutrient to which footnote applies.
    Nutr_No varchar(3) null,

    -- Footnote text.
    Footnt_Txt varchar(200) not null
);

-- File FD_GROUP.txt: Food Group Description
create table FD_GROUP (
    -- 4-digit code identifying a food group. Only the first 2 digits are currently assigned. In the future, the last 2 digits may be used. Codes may not be consecutive.
    FdGrp_Cd varchar(4) not null,

    -- Name of food group.
    FdGrp_Desc varchar(60) not null
);
alter table FD_GROUP add primary key (FdGrp_Cd);

-- File LANGUAL.txt: LanguaL Factor
create table LANGUAL (
    -- 5-digit Nutrient Databank number that uniquely identifies a food item. If this field is defined as numeric, the leading zero will be lost.
    NDB_No varchar(5) not null,

    -- The LanguaL factor from the Thesaurus
    Factor_Code varchar(5) not null
);
alter table LANGUAL add primary key (NDB_No, Factor_Code);

-- File LANGDESC.txt: LanguaL Factors Description
create table LANGDESC (
    -- The LanguaL factor from the Thesaurus. Only those codes used to factor the foods contained in the LanguaL Factor file are included in this file
    Factor_Code varchar(5) not null,

    -- The description of the LanguaL Factor Code from the thesaurus
    Description varchar(140) not null
);
alter table LANGDESC add primary key (Factor_Code);

-- File NUTR_DEF.txt: Nutrient Definition
create table NUTR_DEF (
    -- Unique 3-digit identifier code for a nutrient.
    Nutr_No varchar(3) not null,

    -- Units of measure (mg, g, mcg, and so on).
    Units varchar(7) not null,

    -- International Network of Food Data Systems (INFOODS) Tagnames. (INFOODS, 2009.) A unique abbreviation for a nutrient/food component developed by INFOODS to aid in the interchange of data.
    Tagname varchar(20) null,

    -- Name of nutrient/food component.
    NutrDesc varchar(60) not null,

    -- Number of decimal places to which a nutrient value is rounded.
    Num_Dec varchar(1) not null,

    -- Used to sort nutrient records in the same order as various reports produced from SR.
    SR_Order mediumint(6) unsigned not null
);
alter table NUTR_DEF add primary key (Nutr_No);

-- File SRC_CD.txt: Source Code
create table SRC_CD (
    -- 2-digit code.
    Src_Cd varchar(2) not null,

    -- Description of source code that identifies the type of nutrient data.
    SrcCd_Desc varchar(60) not null
);
alter table SRC_CD add primary key (Src_Cd);

-- File DERIV_CD.txt: Data Derivation Description
create table DERIV_CD (
    -- Derivation Code.
    Deriv_Cd varchar(4) not null,

    -- Description of derivation code giving specific information on how the value was determined.
    Deriv_Desc varchar(263) not null
);
alter table DERIV_CD add primary key (Deriv_Cd);

-- File DATA_SRC.txt: Sources of Data
create table DATA_SRC (
    -- Unique number identifying the reference/source.
    DataSrc_ID varchar(6) not null,

    -- List of authors for a journal article or name of sponsoring organization for other documents.
    Authors varchar(255) null,

    -- Title of article or name of document, such as a report from a company or trade association.
    Title varchar(255) not null,

    -- Year article or document was published.
    Year varchar(4) null,

    -- Name of the journal in which the article was published.
    Journal varchar(135) null,

    -- Volume number for journal articles, books, or reports; city where sponsoring organization is located.
    Vol_City varchar(16) null,

    -- Issue number for journal article; State where the sponsoring organization is located.
    Issue_State varchar(5) null,

    -- Starting page number of article/document.
    Start_Page varchar(5) null,

    -- Ending page number of article/document.
    End_Page varchar(5) null
);
alter table DATA_SRC add primary key (DataSrc_ID);

-- File DATSRCLN.txt: Sources of Data Link
create table DATSRCLN (
    -- 5-digit Nutrient Databank number.
    NDB_No varchar(5) not null,

    -- Unique 3-digit identifier code for a nutrient.
    Nutr_No varchar(3) not null,

    -- Unique ID identifying the reference/source.
    DataSrc_ID varchar(6) not null
);
alter table DATSRCLN add primary key (NDB_No, Nutr_No, DataSrc_ID);

load data infile '/Users/maarten/m5n/food/data/FOOD_DES.txt' into table FOOD_DES fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from FOOD_DES);
delete from tmp where c = 7907;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/NUT_DATA.txt' into table NUT_DATA fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from NUT_DATA);
delete from tmp where c = 583957;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/WEIGHT.txt' into table WEIGHT fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from WEIGHT);
delete from tmp where c = 13817;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/FOOTNOTE.txt' into table FOOTNOTE fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from FOOTNOTE);
delete from tmp where c = 522;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/FD_GROUP.txt' into table FD_GROUP fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from FD_GROUP);
delete from tmp where c = 25;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/LANGUAL.txt' into table LANGUAL fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from LANGUAL);
delete from tmp where c = 40205;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/LANGDESC.txt' into table LANGDESC fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from LANGDESC);
delete from tmp where c = 774;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/NUTR_DEF.txt' into table NUTR_DEF fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from NUTR_DEF);
delete from tmp where c = 146;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/SRC_CD.txt' into table SRC_CD fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from SRC_CD);
delete from tmp where c = 10;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/DERIV_CD.txt' into table DERIV_CD fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from DERIV_CD);
delete from tmp where c = 54;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/DATA_SRC.txt' into table DATA_SRC fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from DATA_SRC);
delete from tmp where c = 589;
insert into tmp (select count(*) from tmp);
drop table tmp;

load data infile '/Users/maarten/m5n/food/data/DATSRCLN.txt' into table DATSRCLN fields terminated by '^' optionally enclosed by '~' lines terminated by '\r\n';
create table tmp (c int unique key);
insert into tmp (c) values (2);
insert into tmp (select count(*) from DATSRCLN);
delete from tmp where c = 171155;
insert into tmp (select count(*) from tmp);
drop table tmp;

insert into DERIV_CD (Deriv_Desc, Deriv_Cd) values ('Added by http://github/m5n/usda-nutrient-database-sql-port to avoid foreign key error on NUT_DATA', '');
insert into FOOD_DES (Shrt_Desc, NDB_No, FdGrp_Cd, Long_Desc) values ('See Long_Desc', '', '0100', 'Added by http://github/m5n/usda-nutrient-database-sql-port to avoid foreign key error on NUT_DATA');
insert into NUTR_DEF (NutrDesc, Sr_Order, Units, Nutr_No, Num_Dec) values ('Added by http://github/m5n/usda-nutrient-database-sql-port to avoid foreign key error on FOOTNOTE', '0', 'g', '', '0');

alter table FOOD_DES add foreign key (FdGrp_Cd) references FD_GROUP(FdGrp_Cd);
alter table NUT_DATA add foreign key (NDB_No) references FOOD_DES(NDB_No);
alter table NUT_DATA add foreign key (Nutr_No) references NUTR_DEF(Nutr_No);
alter table NUT_DATA add foreign key (Src_Cd) references SRC_CD(Src_Cd);
alter table NUT_DATA add foreign key (Deriv_Cd) references DERIV_CD(Deriv_Cd);
alter table NUT_DATA add foreign key (Ref_NDB_No) references FOOD_DES(NDB_No);
alter table WEIGHT add foreign key (NDB_No) references FOOD_DES(NDB_No);
alter table FOOTNOTE add foreign key (NDB_No) references FOOD_DES(NDB_No);
alter table FOOTNOTE add foreign key (Nutr_No) references NUTR_DEF(Nutr_No);
alter table LANGUAL add foreign key (NDB_No) references FOOD_DES(NDB_No);
alter table LANGUAL add foreign key (Factor_Code) references LANGDESC(Factor_Code);
alter table DATSRCLN add foreign key (NDB_No) references FOOD_DES(NDB_No);
alter table DATSRCLN add foreign key (Nutr_No) references NUTR_DEF(Nutr_No);
alter table DATSRCLN add foreign key (DataSrc_ID) references DATA_SRC(DataSrc_ID);
