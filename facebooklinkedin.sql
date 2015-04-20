create database facelink
use facelink
create table USERS(
	user_id int not null identity(0,1),
	user_name varchar(20) not null,
	password varchar(20) not null,
	first_name varchar(20) not null,
	middle_name varchar(20),
	last_name varchar(30) not null,
	email varchar(40) not null,
	active bit not null,
	created_date datetime not null,
	the_online bit not null,
	with_relationship_id int default (0),
	relationship_details varchar(50),
	constraint USERPK
		primary key(user_id),
	constraint MAILSK
		unique(email),
	constraint USERNAMESK
		unique(user_name),
	constraint passw_const check (len(password)>6),
	foreign key (with_relationship_id) references USERS(user_id)		
);

create table ORGANIZATIONS(
	organization_id int not null identity(0,1),
	organization_name varchar(40),
	description varchar(50),
	constraint ORGNZTIONPK
		primary key(organization_id),
);

create table FAVORITE(
	favorite_id int not null identity(0,1),
	fav_animals varchar(255),
	fav_movies varchar(255),
	fav_musics varchar(255),
	fav_artists varchar(255),
	fav_books varchar(255),
	fav_series varchar(255),
	fav_authors varchar(255),
	constraint FAVPK
		primary key(favorite_id),
);

create table PROFILE(
	profile_id int not null identity(1,1),
	user_id int not null,
	gender char(1) not null check(gender='M' or gender='F'),
	religion varchar(20),
	picture varchar(255),
	privacy tinyint default(0),
	hobbies varchar(255),
	favorite_id int default(0),
	interest varchar(255),
	birth_date datetime not null,
	phone varchar(20),
	education varchar(255),
	looking_for varchar(45),
	about_me varchar(200),
	everything_else varchar(255),
	update_date datetime not null,
	current_organization_id int default (0),
	
	constraint PROFILEPK
		primary key (profile_id),
	constraint PROFILEUSERFK
		foreign key (user_id) references USERS(user_id)
			on delete cascade on update cascade,
	constraint PROFILEORGFK
		foreign key(current_organization_id) references ORGANIZATIONS(organization_id)
			on delete set default on update cascade,
	constraint PROFILEFAVFK
		foreign key(favorite_id) references FAVORITE(favorite_id)
			on delete set default on update cascade,
	constraint PROFILESK
		unique(user_id),
);

create table COUNTRY(
	country_id int not null identity(1,1),
	country_name varchar(45),
	constraint COUNTRYPK
		primary key(country_id),
);

create table CITY(
	city_id int not null identity(1,1),
	country_id int not null,
	city_name varchar(45),
	constraint CITYPK
		primary key(city_id),
	constraint CITYCOUNTRYFK
		foreign key(country_id) references COUNTRY(country_id)
			on delete cascade on update cascade
);

create table ADDRESS(
	address_id int not null identity(1,1),
	address_name varchar(60),
	privacy tinyint default(0),
	zip_or_postcode varchar(20),
	city_id int not null,
	profile_id int not null,
	
	constraint ADDRESSPK
		primary key(address_id),
	constraint ADDRESSCITYFK
		foreign key(city_id) references CITY(city_id)
			on delete cascade on update cascade,
	constraint ADDRESSPROFILEFK
		foreign key(profile_id) references PROFILE(profile_id)
			on delete cascade on update cascade
);
 
 create table LANGUAGE(
	language_id int not null identity(1,1),
	lang_description varchar(20),
	user_id int not null,

	constraint LANGUAGEPK
		primary key(language_id,user_id),
	constraint LANGUAGEUSERFK
		foreign key(user_id) references USERS(user_id)
			on delete cascade on update cascade
);

create table GROUPS(
	group_id int not null identity(1,1),
	group_leader_id int not null default(0),
	group_name varchar(50),
	created_date datetime,
	ended_date datetime,
	last_activity varchar(100),
	description varchar(50),
	
	constraint GROUPSPK
		primary key (group_id),
	constraint GROUPLEADERFK
		foreign key(group_leader_id) references USERS(user_id)
			on delete set default on update cascade
);
	
create table NOTIFICATIONS(
	notification_id int not null identity(1,1),
	message varchar(200),
	type smallint,
	privacy tinyint,
	created_at datetime not null,
	to_user_id int not null,

	constraint NOTIFIPK
		primary key(notification_id),
	constraint NOTIFYTOUSERFK
		foreign key(to_user_id) references USERS (user_id)
			on delete cascade on update cascade
);	

create table FRIENDREQUEST(
	user_id int not null,
	take_req_user_id int not null,
	request_date datetime not null,
	accepted_flag bit default(0),

	constraint FRIREQPK
		primary key(user_id,take_req_user_id),
	constraint FRIREQUSERFK
		foreign key(user_id) references USERS(user_id)
			on delete cascade on update cascade,
	foreign key(take_req_user_id) references USERS(user_id),
	constraint req_constr check (user_id!=take_req_user_id),
	constraint time_constr check(request_date<=getdate()),
);	

create table FRIEND(
	friend_id int not null identity(1,1),
	user_id int not null,
	friend_to_id int not null,
	created_at datetime not null,
	is_subscriber bit not null,
	privacy	tinyint default(0),
	
	constraint FRIENDPK
		primary key(friend_id),
	constraint FRIENDUSERFK
		foreign key(user_id) references USERS(user_id)
			on delete cascade on update cascade,
	foreign key(friend_to_id) references USERS(user_id),
	constraint friend_const check (user_id!=friend_to_id),
);	

create table FRIENDLIST(
	user_id int not null ,
	privacy tinyint  default(0),
	numberOfFriends int,
	
	constraint FRILISTPK
		primary key(user_id),
	foreign key(user_id) references USERS (user_id)
);

create table SUB_FRIENDLIST(
	user_id int not null,
	sub_friendlist_id int not null default(0),
	friend_id int not null,
	sub_friendlist_name varchar(30),
	
	constraint SUBFRILISTPK
		primary key(user_id,sub_friendlist_id,friend_id),
	constraint SUBFRILISTFRIENDFK
		foreign key(friend_id) references FRIEND(friend_id)
			on delete cascade on update cascade,
	foreign key(user_id) references FRIENDLIST(user_id)
);
    
create table STATUS(
	status_id int not null identity(1,1),
	message varchar(250),
	created_at datetime not null,
	thumbs_up smallint,
	privacy tinyint default(0),
	is_reply bit,
	is_share bit,
	to_twitter bit,
	user_id int not null,
	
	constraint STATUSPK
		primary key (status_id),
	constraint STATUSUSERFK
		foreign key(user_id) references USERS(user_id)
			on delete cascade on update cascade
);	
	
create table THUMB_UP(
	thumb_up_id int not null identity(1,1),
	status_id int not null,
	flag bit default(0),
	created_at datetime not null,
	user_id int not null,
	
	constraint THUMBPK
		primary key(thumb_up_id),
	constraint THUMBSK
		unique(status_id,user_id),
	constraint THUMBSTATUSFK
		foreign key(status_id) references STATUS(status_id)
			on delete cascade on update cascade,
	foreign key(user_id) references USERS(user_id)
);
	
create table COMMENT(
	comment_id int not null identity(1,1),
	status_id int not null,
	message varchar(250),
	created_at datetime not null,
	user_id int not null,
	
	constraint COMMENTPK
		primary key(comment_id),
	constraint COMMENTSTATUSFK
		foreign key(status_id) references STATUS(status_id)
			on delete cascade on update cascade,
	foreign key(user_id) references USERS(user_id)
);

create table SHARE(
	share_id int not null identity(1,1),
	status_id int not null,
	title_msg varchar(250),
	created_at datetime not null,
	user_id int not null,
	
	constraint SHAREPK
		primary key(share_id),
	constraint SHARESTATUSFK
		foreign key(status_id) references STATUS(status_id)
			on delete cascade on update cascade,
	foreign key(user_id) references USERS(user_id)
);

/*drop table SHARE;*/

create table GROUPMEMBER(
	group_id int not null,
	user_id int not null,
	join_date datetime,
	left_date datetime,
	
	constraint GROUPMEMBERPK
		primary key(group_id,user_id),
	constraint GROUPMEMBERGROUPFK
		foreign key(group_id) references GROUPS(group_id)
			on delete cascade on update cascade,
	foreign key(user_id) references USERS(user_id),
	constraint group_constr check(join_date<left_date),
);

create table RECOMMENDATIONS(
	recommendation_id int not null identity(1,1),
	give_rec_user_id int not null,
	take_rec_user_id int not null,
	created_at datetime not null,
	about varchar(200),
	
	constraint RECOMPK
		primary key(recommendation_id),
	constraint RECOMGIVERECUSER
		foreign key(give_rec_user_id) references USERS (user_id)
			on delete cascade on update cascade,
	foreign key(take_rec_user_id) references USERS (user_id),
	constraint rec_constr check(give_rec_user_id!=take_rec_user_id),
);

create table FOLLOW(
	follow_id int not null identity(1,1),
	follow_up_id int not null,
	followed_id int not null,
	created_at datetime not null,
	stopped_at datetime default('9999-12-31 00:00:00') ,
	
	constraint FOLLOWPK
		primary key(follow_id),
	constraint FOLLOWUPUSERFK
		foreign key(follow_up_id) references USERS (user_id)
			on delete cascade on update cascade,
	foreign key(followed_id) references USERS (user_id),
	constraint follow_constr check(follow_up_id!=followed_id),
	constraint follow_constr2 check(created_at<stopped_at),
);

create table EVENT(
	event_id int not null identity(1,1),
	event_title varchar(50) not null,
	start_at datetime not null,
	finished_at datetime not null,
	creator_id int not null,
	privacy tinyint default(0),
	content varchar(250),
	event_picture varchar(60),
	
	constraint EVENTPK
		primary key (event_id),
	constraint check_date check (start_at<=finished_at),
	constraint EVENTCREATORFK
		foreign key(creator_id) references USERS(user_id)
			on delete cascade on update cascade
);

create table EVENTMEMBER(
	event_id int not null,
	user_id int not null,
	
	constraint EVENTMEMBERPK
		primary key(event_id,user_id),
	constraint EVENTMEMBEREVENTFK
		foreign key(event_id) references EVENT(event_id)
			on delete cascade on update cascade,
	foreign key(user_id) references USERS(user_id)
);

create table CHAT(
	chat_id int not null identity(1,1),
	chatting_with_id int not null,
	message varchar(max),
	created_at datetime not null,
	
	constraint CHATPK
		primary key(chat_id),
	constraint CHATSK
		unique(chatting_with_id,created_at),
	constraint CHATUSERFK
		foreign key(chatting_with_id) references FRIEND(friend_id)
			on delete cascade on update cascade
);

create table MESSAGES(
	message_id int not null identity(1,1),
	message varchar(250),
	created_at datetime not null,
	is_read bit,
	is_spam bit,
	is_reply bit,
	user_id int not null,
	to_user_id int not null,
	
	constraint MESSAGESPK
		primary key(message_id),
	constraint MESSAGESSK
		unique(user_id,to_user_id,created_at),
	constraint MESSAGESUSERFK
		foreign key(user_id) references USERS(user_id)
			on delete cascade on update cascade,
	foreign key(to_user_id) references USERS(user_id),
	constraint send_const check (created_at<= getdate()),
);

create table BOOKMARKCATEGORY(
	bookmark_category_id int not null identity(1,1),
	name varchar(50),

	constraint BOOKMARKCATEPK
		primary key(bookmark_category_id),
);

create table BOOKMARK_SUB_CATEGORY(
	bookmark_sub_category_id int not null identity(1,1),
	bookmark_category_id int,
	name varchar(50),

	constraint BOOKMARKSUBCATEPK
		primary key(bookmark_sub_category_id),
	foreign key(bookmark_category_id) references BOOKMARKCATEGORY(bookmark_category_id)
);

create table BOOKMARK(
	bookmark_id int not null identity(1,1),
	bookmark_category_id int,
	bookmark_sub_category_id int,
	url varchar(250),
	privacy tinyint,
	created_at datetime not null,

	constraint BOOKMARKSK
		unique(url),
	constraint BOOKMARKPK
		primary key(bookmark_id),
	constraint BOOKMARKCATEFK
		foreign key(bookmark_category_id) references BOOKMARKCATEGORY(bookmark_category_id)
			on delete cascade on update cascade,
	constraint BOOKMARKSUBCATEFK
		foreign key(bookmark_sub_category_id) references BOOKMARK_SUB_CATEGORY(bookmark_sub_category_id)
			on delete cascade on update cascade
);

create table BOOKMARK_INFO(
	bookmark_info_id int not null identity(1,1),
	bookmark_id int,
	user_id int not null,
	favorite bit,
	clicks smallint,
	privacy tinyint,
	
	constraint BOOKMARKINFOPK
		primary key(bookmark_info_id),
	constraint BOOKMARKINFOBOOKMARKFK
		foreign key(bookmark_id) references BOOKMARK(bookmark_id)
			on delete cascade on update cascade,
	constraint BOOKMARKINFOUSER
		foreign key(user_id) references USERS(user_id)
			on delete cascade on update cascade
);

/*drop table BOOKMARK_INFO;*/

create table FEED_CATEGORY(
	feed_category_id int not null identity(1,1),
	name varchar(50),
	
	constraint FEEDCATEPK
		primary key (feed_category_id),
);

create table FEED_SUB_CATEGORY(
	feed_sub_category_id int not null identity(1,1),
	name varchar(50),
	feed_category_id int

	constraint FEEDSUBCATEPK
		primary key (feed_sub_category_id),
	foreign key (feed_category_id) references FEED_CATEGORY(feed_category_id)
);

create table FEED(
	feed_id bigint not null identity(1,1),
	feed_category_id int,
	feed_sub_category_id int,
	feed_url varchar(255),
	rating smallint ,
	privacy tinyint,
	created_at datetime not null,

	constraint FEEDSK
		unique(feed_url),
	constraint FEEDPK
		primary key (feed_id),
	constraint FEEDCATEFK
		foreign key (feed_category_id) references FEED_CATEGORY(feed_category_id)
			on delete cascade on update cascade,
	constraint FEEDSUBCATEFK
		foreign key (feed_sub_category_id) references FEED_SUB_CATEGORY(feed_sub_category_id)
			on delete cascade on update cascade
);

create table FEED_INFO(
	feed_info_id int not null identity(1,1),
	feed_id bigint,
	user_id int,
	favorite bit,
	clicks smallint,
	privacy tinyint,
	
	constraint FEEDINFOPK
		primary key (feed_info_id),
	constraint FEEDINFOUSERFK
		foreign key (user_id) references USERS(user_id)
			on delete cascade on update cascade,
	constraint FEEDINFOFEEDFK
		foreign key (feed_id) references FEED(feed_id)
			on delete cascade on update cascade
);

create table PRIVACY(
	privacy_id int not null identity(1,1),
	profile tinyint,
	address tinyint,
	status tinyint,
	bookmark tinyint,
	feed tinyint,
	friend tinyint,
	activity tinyint,
	friendlist tinyint,
	user_id int,
	
	constraint PRIVACYSK
		unique(user_id),
	constraint PRIVACYPK
		primary key(privacy_id),
	constraint PRIVACYUSERFK
		foreign key(user_id) references USERS(user_id)
			on delete cascade on update cascade
);	
    
create table CV(
	cv_id int not null identity (0,1),
	user_id int,
	created_at datetime,
	updated_at datetime,
	ref_cv_id int default(0),
	
	constraint CVPK
		primary key(cv_id),
	foreign key(user_id) references USERS(user_id),
	/*constraint date_cons check (created_at<=updated_at),*/
	foreign key(ref_cv_id) references CV(cv_id)
);

create table CV_SKILLS(
	cv_skills_id int not null identity(1,1),
	skills varchar(40),
	cv_id int not null,
	
	constraint CVSKILLSSK
		unique(cv_id,skills),
	constraint CVSKILLSPK
		primary key(cv_skills_id),
	constraint CVSKILLSCVFK
		foreign key(cv_id) references CV(cv_id)
			on delete cascade on update cascade
);
	
create table DIARY(
	diary_id int not null identity(1,1),
	user_id int not null,
	privacy tinyint default(2),
	author_name varchar(30) not null,
	message varchar(max),
	created_at datetime not null,
	
	constraint DIARYSK
		unique(user_id,created_at),
	constraint DIARYPK
		primary key (diary_id),
	constraint DIARYUSERFK
		foreign key(user_id) references USERS (user_id)
			on delete cascade on update cascade,
	constraint diary_const check (created_at<=getdate()),
);


	go
	create trigger status_thumbup
	on THUMB_UP
	AFTER INSERT
	AS BEGIN
	declare @flag_id bit,@sta_id int
	begin
		declare inc_thumbup cursor for
		select flag,status_id from inserted

		open inc_thumbup
		fetch next from inc_thumbup into @flag_id,@sta_id
		while @@FETCH_STATUS=0
		begin 
			update STATUS set thumbs_up=thumbs_up+1
			from STATUS
			where status_id=@sta_id and @flag_id=1
			fetch next from inc_thumbup into @flag_id,@sta_id
		end
		close inc_thumbup
		deallocate inc_thumbup
	end
	end;


	go
	create trigger friend_accept
	on FRIENDREQUEST
	AFTER UPDATE
	AS BEGIN
	declare @accepted bit, @to_user int, @user int
	select @accepted=accepted_flag, @to_user=take_req_user_id, @user=user_id from inserted
	if @accepted='1'
	begin
		insert into FRIEND values (@user,@to_user,getdate(),1,0)
		insert into FRIEND values (@to_user,@user,getdate(),1,0)
		insert into SUB_FRIENDLIST values (@user,0,(select friend_id from FRIEND where user_id=@user and friend_to_id=@to_user),null)
		insert into SUB_FRIENDLIST values (@to_user,0,(select friend_id from FRIEND where user_id=@to_user and friend_to_id=@user),null)
		delete from FRIENDREQUEST where user_id=@user and take_req_user_id=@to_user
	end
	end;


	go
	create trigger friendlist_batch
	on FRIEND
	AFTER INSERT
	AS BEGIN
	declare @user_id int
	begin
		declare inc_friend cursor for
		select user_id from inserted

		open inc_friend
		fetch next from inc_friend into @user_id
		while @@FETCH_STATUS=0
		begin
			update FRIENDLIST set numberOfFriends=numberOfFriends+1 where user_id=@user_id
		fetch next from inc_friend into @user_id
		end
		close inc_friend
		deallocate inc_friend
	end
	end;

	
	go
	create trigger bookmarkCategoryDelete
	on BOOKMARKCATEGORY
	INSTEAD OF DELETE
	AS BEGIN
	declare @b_cat_id int
	select @b_cat_id=bookmark_category_id from deleted
		delete from BOOKMARK_SUB_CATEGORY where bookmark_category_id=@b_cat_id
		delete from BOOKMARKCATEGORY where bookmark_category_id=@b_cat_id
	end;

	
	go
	create trigger feedCategoryDelete
	on FEED_CATEGORY
	INSTEAD OF DELETE
	AS BEGIN
	declare @f_cat_id int
	select @f_cat_id=feed_category_id from deleted
		delete from FEED_SUB_CATEGORY where feed_category_id=@f_cat_id
		delete from FEED_CATEGORY where feed_category_id=@f_cat_id
	end;


	go
	create trigger friendlistDelete
	on FRIENDLIST
	INSTEAD OF DELETE
	AS BEGIN
	declare @user_id int
	select @user_id=user_id from deleted
		delete from SUB_FRIENDLIST where user_id=@user_id
		delete from FRIENDLIST where user_id=@user_id
	end;


	go
	create trigger cvDelete
	on CV
	INSTEAD OF DELETE
	AS BEGIN
	declare @cv_id int
	begin
		declare ref_cv2 cursor for
		select cv_id from deleted

		open ref_cv2
		fetch next from ref_cv2 into @cv_id
		while @@FETCH_STATUS=0
		begin
		update CV set ref_cv_id=0 where ref_cv_id=@cv_id
		delete from CV where cv_id=@cv_id
		fetch next from ref_cv2 into @cv_id
		end
		close ref_cv2
		deallocate ref_cv2
	end
	end;


	go
	create trigger userDelete
	on USERS
	INSTEAD OF DELETE
	AS BEGIN
	declare @u_id int,@rela_id int
	select @u_id=user_id,@rela_id=with_relationship_id from deleted
	begin
		delete from FRIENDREQUEST where take_req_user_id=@u_id
		delete from FRIEND where friend_to_id=@u_id
		delete from FRIENDLIST where user_id=@u_id
		delete from THUMB_UP where user_id=@u_id
		delete from COMMENT where user_id=@u_id
		delete from SHARE where user_id=@u_id
		delete from GROUPMEMBER where user_id=@u_id
		delete from RECOMMENDATIONS where take_rec_user_id=@u_id
		delete from FOLLOW where followed_id=@u_id
		delete from EVENTMEMBER where user_id=@u_id
		delete from MESSAGES where to_user_id=@u_id
		delete from CV where user_id=@u_id
		update USERS set with_relationship_id=0 where user_id=@rela_id
		delete from USERS where user_id=@u_id
	end
	end;
	

	 go
     create trigger relationship
     on USERS
     after update 
     as begin
	 declare @user_id int,@w_id int
	 select @user_id=user_id, @w_id=with_relationship_id from inserted
		update USERS set with_relationship_id=@user_id where user_id=@w_id
	 end;  


    insert into USERS values ('DEFAULT','DEFAULT','DEFAULT','','DEFAULT','DEFAULT','0','1800-01-01 00:00:00','0',NULL,NULL),
	('Can48','0000000','Can','','Güzel','cang@gmail.com','1','2014-01-01 00:00:00','1',null,'evli'),
    ('Cengiz60','0000001','Cengiz','','Bursalýoðlu','cengizbursali@gmail.com','1','2014-01-11 00:00:01','1',null,null),
    ('Þahin48','0000002','Þahin','','Dirim','sahindirim@gmail.com','1','2014-01-11 00:00:02','1',null,null),
    ('Anýl35','0000004','Anýl','','Öztürk','anil3@gmail.com','1','2014-11-11 00:00:03','0',null,'metres'),
    ('Asým40','0000003','Asým','','Zorlu','asimzorlu@gmail.com','1','2011-01-11 00:00:04','1',null,'evli'),
    ('Coolmortal','0000003','Görkem','Taylan','Gündeþoðlu','gorkemtaylan@gmail.com','1','2010-01-11 00:00:05','1',null,null);
      select * from USERS;


      insert into ORGANIZATIONS values (NULL,NULL),
	  ('Vestel','Türkiye vestelleniyor.'),
      ('Apple','Apple da çalýþmak ayrýcalýktýr.'),
      ('Yemeksepeti','Anýnda yemek evinizde.'),
      ('Koç sistem','Askeri ücret verilir.'),
      ('Argefar','Sýcak içecek bedava.');
      select * from ORGANIZATIONS;
      
      insert into FAVORITE values (NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	  ('Eþek','Esaretin Bedeli','metal','Brad Pitt','Tanrý yanýlgýsý','Friends','Richard Dawnkings'),
      ('Papaðan','Unutursam Fýsýlda','pop,rock','Cem yýlmaz','melekler ve þeytanlar','doctor who','Dan Browns'),
      ('Eþek','Esaretin Bedeli','metal','Brad Pitt','Tanrý yanýlgýsý','game of thrones','Richard Dawnkings');
      select * from FAVORITE;
     
      insert into PROFILE values(5,'M','Ateist','çiçek',1,'play guitar',2,'yazýlým','1993-10-10','','ege üniversitesi','iþ arýyor','müzik benim hayatým','','2014-11-24',1),
      (1,'M','Teist','böcek',2,'play game',1,'donaným','1992-10-10','542 970 80 50','ege üniversitesi','arkadaþ arýyor','hayat benim hayatým','uygun bayanlarý beklerim','2013-11-24',1),
      (2,'F','Müslüman','kedi',1,'kuran okumak',null,'dikiþ-nakýþ','1994-10-10','','ege üniversitesi','iþ ve aþk arýyor','yaradandýr','','2014-01-24',2),
      (3,'M','','kendi resmi',1,'play station',2,'play game','1992-08-10','','ege üniversitesi','okeye 4.arýyor','oyun benim hayatým','','2014-11-24',3),
      (4,'F','Ateist','kitap',1,'satranç',2,'yazýlým','1993-10-10','545 448 48 60','dokuz eylül üniversitesi','arkadaþ arýyor','bilim benim hayatým','','2014-11-14',5),
      (6,'M','Hristiyan','araba',0,'play guitar',2,'fotoðraf','1990-10-10','','yaþar üniversitesi','iþ arýyor','kariyer benim hayatým','para para para','2014-07-24',4);
      select * from PROFILE;
      
      insert into COUNTRY values('Türkiye'),('Ýngiltere'),('Ýtalya'),('Fransa'),('Almanya'),('Amerika'),('Ýspanya');
      select * from COUNTRY;
      
      insert into CITY values(2,'londra'),(1,'izmir'),(1,'istanbul'),(3,'Roma'),(4,'paris'),(5,'Münih'),(6,'new york'),(7,'madrid');
      select * from CITY;
      
      
      insert into ADDRESS values('bornova/Ýzmir',0,'35100',2,3),
      ('buca/Ýzmir',0,'35200',2,3),
      ('beylikdüzü/Ýstanbul',1,'34100',3,1),
      ('centry/Londra',0,'33100',1,2),
      ('centry/Paris',0,'',5,4),
      ('centry/münih',0,'',6,5),
      ('centry/new york',1,'154565',7,6);
      select * from ADDRESS;
      
      insert into LANGUAGE values ('ingilizce',1),
      ('Franszýca',1),
      ('Türkçe',1),
      ('Türkçe',6),
      ('Türkçe',2),
      ('Almanca',4),
      ('Fransýzca',3),
      ('Türkçe',3),
      ('ingilizce',5);
      select * from LANGUAGE;
      
      insert into GROUPS values (1,'idda tips','2014-12-20','','salzburg h1','kazanmak burada!'),
      (1,'vecdi snejder','2014-12-10','','salzburg h1','para burada!'),
      (2,'bisiklet kulübü','2014-12-11','','dikili turu','activite burada!'),
      (3,'bilgisayar mühendisliði','2014-02-20','','database sýnav sorularý','paylaþýn');
      select * from GROUPS;
      
      insert into NOTIFICATIONS values ('senin fotoðrafýný beðendi',1,2,'2014-12-10',6),
      ('senin fotoðrafýný beðendi',1,2,'2014-12-10',2),
      ('senin fotoðrafýný beðendi',1,2,'2014-12-10',6),
      ('grupta etkinlik baþlatýldý',0,1,'2014-12-11',1),
      ('senin fotoðrafýn yorum yaptý',1,1,'2014-11-10',3);
       select * from NOTIFICATIONS;
         
	   insert into FRIENDLIST values(1,2,0),
      (2,1,0),
      (3,0,0),
      (4,2,0),
      (5,0,0),
      (6,1,0);
      select * from FRIENDLIST;

	  insert into FRIEND values(2,1,'2014-10-09',1,1),
      (1,2,'2014-10-08',1,1),
      (4,1,'2014-10-09',1,1),
      (1,4,'2014-10-09',1,1),
      (6,1,'2014-10-09',1,1),
      (1,6,'2014-10-09',1,1),
	  (5,6,'2014-10-09',1,1),
	  (6,5,'2014-10-09',1,1),
	  (3,1,'2014-10-09',1,1),
	  (1,3,'2014-10-09',1,1),
	  (5,2,'2014-10-09',1,1),
      (2,5,'2014-10-09',1,1),
	  (3,4,'2014-10-09',1,1),	
	  (4,3,'2014-10-09',1,1);

      select * from FRIEND;

      insert into SUB_FRIENDLIST values (1,1,1,'tüm arkadaþlar'),
      (1,1,3,'tüm arkadaþlar'),
      (1,1,5,'tüm arkadaþlar'),
      (1,2,9,'iþ'),
      (2,1,2,'ev'),
      (2,2,11,'okul'),
      (3,1,10,'üniversiteden'),
      (3,1,14,'üniversiteden'),
      (4,1,4,'iþ'),
      (4,2,13,'memleket'),
      (4,3,13,'tüm arkadaþlar'),
      (5,1,8,'üniversiteden'),
      (5,2,8,'lise'),
      (5,3,8,'iþ'),
      (5,4,12,'memleket'),
      (6,1,6,'tüm arkadaþlar'),
      (6,1,7,'tüm arkadaþlar');
      
      select * from SUB_FRIENDLIST;
     
      
      insert into STATUS values('hayat boþ..:)','2014-10-22',0,'',1,1,0,1),
      ('bastýr fener..:)','2014-10-12',0,'',1,0,0,2),
      ('gs gene 4 yedi!. ','2014-11-22',0,'',1,1,1,3);
      select * from STATUS;
      
      insert into THUMB_UP values(1,1,'2014-10-22',1),
      (2,1,'2014-12-22',3),
      (3,'','2014-12-22',2),
      (1,1,'2014-12-22',4),
      (1,1,'2014-12-22',5);
      
      select * from THUMB_UP;
      
      insert into COMMENT values(1,'pompayla koþ:D','2014-12-22',2),
      (2,'fener!!','2014-12-22',3),
      (3,'ulan burak','2014-12-22',6);
      
      
      select * from COMMENT;
      
      insert into SHARE values(1,'aynen kanka','2014-12-20',2),
      (2,'fenerim ya','2014-12-20',1),
      (3,'...','2014-12-20',4);
      
      select * from SHARE;
      
      insert into GROUPMEMBER values(1,1,'2014-10-10',null);
      insert into GROUPMEMBER values(1,2,'2014-10-10','2014-10-11'),
      (1,3,'2014-10-10','2014-10-11'),
      (1,4,'2014-10-10','2014-10-11'),
      /*(2,1,'2014-10-10','2014-10-11'),*/
      (2,2,'2014-10-10',null),
      (2,3,'2014-10-10','2014-10-11'),
      (2,4,'2014-10-10','2014-10-11'),
      (3,1,'2014-10-10',null),
      /*(3,2,'2014-10-10',null),*/
      (3,3,'2014-10-10',null),
      (3,4,'2014-10-10',null);
      
      select * from GROUPMEMBER;
     
	  insert into RECOMMENDATIONS values(1,2,'2014-10-22','database dersine iyi çalýþmalýsýn'),	
      (2,1,'2014-10-22','sende nesneye dersine çalýþmalýsýn');
      
      select * from RECOMMENDATIONS;	
      
      insert into FOLLOW values(1,2,'2014-10-22','2014-11-22'),
      (2,3,'2014-10-22',null),
      (3,2,'2014-10-22',null),
      (3,4,'2014-10-22',null),
      (1,3,'2014-10-22',null);
      
      select * from FOLLOW;
      
      insert into EVENT values('þirince gezisi','2014-10-22','2014-10-24',1,'','çok güzel olcak','þarap'),
      ('teknik gezi','2014-10-22','2014-10-24',2,'','herkes vestelliniyor','TVs,SmartPhones');
      select * from EVENT;
      
      insert into EVENTMEMBER values(1,1),(1,2),(2,1),(2,3),(2,2),(2,4);
      select * from EVENTMEMBER;
      
      insert into CHAT values(2,'tanýþýyo muyuz','2014-10-22'),
      (3,'tanýþýyo muyuz','2014-10-23'),
      (4,'tanýþýyo muyuz','2014-10-24'),
      (1,'hayýr','2014-10-25');
      select * from CHAT;
      
      insert into MESSAGES values('naber kanka','2014-10-15',1,0,1,1,2),
      ('iyidir kanka','2014-10-15',1,0,1,2,1),
      ('naber kanka','2014-10-15',1,0,0,1,3),
      ('','2014-10-15',1,1,1,3,1);
      select * from MESSAGES;
      
      insert into BOOKMARKCATEGORY values('Gruplar'),
      ('Sayfalar');
      select * from BOOKMARKCATEGORY;
      
      insert into BOOKMARK_SUB_CATEGORY values(1,'ege bilgisayar 11 giriþliler'),
      (1,'ege bilgisayar 12 giriþliler'),
      (1,'ege bilgisayar satranç '),
      (2,'ege bilgisayar bilgisayar mühendisliði');
      select * from BOOKMARK_SUB_CATEGORY;
      
      insert into BOOKMARK values(1,1,'http://www.ege11.com',1,'2014-10-22'),
      (1,2,'http://www.ege12.com',1,'2014-10-22'),
      (2,4,'http://www.egebilmuh.com',1,'2014-10-22');
      select * from BOOKMARK;
      
      insert into BOOKMARK_INFO values (1,1,1,10,1),(1,2,0,8,1),(3,1,1,9,0);
      select * from BOOKMARK_INFO;
      
      insert into FEED_CATEGORY values('Haber kaynaðý'),
      ('Mesajlar'),('Etkinlikler');
      select * from FEED_CATEGORY;
      
      insert into FEED_SUB_CATEGORY values('Paylaþýmlar',1),
      ('Beðeniler',1),('Yorumlar',1),('Baðlantýlar',1),('Gelen kutusu',2),
      ('Diðerleri',2),('yaklaþan',3),('ajanda',3),('geçmiþ',3),('oluþtur',3);
      select * from FEED_SUB_CATEGORY;
      
      insert into FEED values(1,2,'http://wwww.feed.com',5,0,'2014-10-22'),
      (1,3,'http://wwww.feed1.com',6,1,'2014-10-22'),
      (1,4,'http://wwww.feed3.com',5,0,'2014-10-23'),
      (1,5,'http://wwww.feed2.com',5,0,'2014-10-22'),
      (2,3,'http://wwww.feed4.com',5,0,'2014-10-22'),
      (2,4,'http://wwww.feed5.com',3,0,'2014-10-22');
      select * from FEED;
      
      insert into FEED_INFO values (1,1,1,5,0),
      (1,1,0,5,0),(1,2,1,5,0),(1,3,1,5,0),(2,1,1,5,0),(3,1,1,5,0);
      select * from FEED_INFO;
      
      insert into PRIVACY values (0,1,1,1,1,2,1,1,1),(1,1,1,1,1,2,1,1,2),
      (0,1,1,1,1,1,1,1,3),(0,1,1,1,1,2,1,1,4),(1,1,1,0,1,1,1,1,5),(1,1,1,0,1,1,1,1,6);
      select * from PRIVACY;
      
     
      insert into CV values (null,null,null,null),
	  (1,'2014-05-10',null,5),
      (1,'2014-05-10',null,3),
      (2,'2014-05-10',null,5),
      (3,'2014-05-10',null,2),
      (4,'2014-05-10',null,1);
      select * from CV;
      
      insert into CV_SKILLS values('c#',1),
      ('java',1),
      ('sql',1),
      ('c++',2),
      ('ios',2),
      ('android',2),
      ('html5',2),
      ('java',3),
      ('mysql',3),
      ('css',3),
      ('asp.net',4),
      ('php',4),
      ('java script',4);
      select * from CV_SKILLS;
      
      insert into DIARY values(1,'','canýn günlüðü','sevgili günlük...','2014-11-22'),
      (2,'','cengizin günlüðü','bugün çok güzeldi...','2014-11-12'),
      (3,'','þahinin günlüðü','bugün bir kýz gördüm...','2014-02-24'),
      (4,'','anýlýn günlüðü','bugün yine ders çalýþtým...','2014-02-22'),
      (5,'','asýmýn günlüðü','nargile içmeye gittik...','2014-12-02'),
      (6,'','görkemin günlüðü','yine kýrmýzý kart gördük karþim...','2014-12-01');
      select * from DIARY;
      
      insert into FRIENDREQUEST values (3,5,'2014-10-22 00:01:02',0),
      (2,4,'2014-10-22 00:01:02',0),
      (2,6,'2014-10-22 00:01:02',0),
      (3,2,'2014-10-22 00:01:02',0);
      select * from FRIENDREQUEST;

	  /*UPDATE DELETE INSERT*/

	  select * from USERS;
	  update USERS set with_relationship_id=3 where user_id=1;
	  update USERS set user_name='CeNGiZ_6996' where user_name='Cengiz60';
	  update USERS set active=0 where user_id=4;
	  update USERS set with_relationship_id=5 where user_id=6;
	  update USERS set relationship_details='bomba' where user_id=6;

	  delete from USERS where user_name='Asým40';
	  delete from USERS where created_date<'2011-05-12' and created_date>'2009-02-25';

	  insert into USERS values ('crazy_boy','0000010','Cristiano','CR7','Ronaldo','jöleli@windowslive.com',1,'2014-04-30 07:08:06',1,null,null);
	  insert into USERS values ('beautiful_girl','0000015','Irina','','Shayk','manken@hotmail.com',1,'2014-05-25 14:19:06',1,null,null);
	  insert into USERS values ('hahahaha','0000020','Hunharca','Gülen','Adam','gülerim@gmail.com',1,'2014-03-02 07:08:06',0,null,null);

	  select * from FRIENDREQUEST;
	  update FRIENDREQUEST set accepted_flag=1 where user_id=3 and take_req_user_id=2;
	  update FRIENDREQUEST set accepted_flag=1 where user_id=2 and take_req_user_id=4;

	  select * from FRIEND;
	  update FRIEND set privacy=2 where user_id=1;
	  update FRIEND set is_subscriber=0 where friend_id=13;
	  
	  insert into PROFILE values (9,'M','Ýmanlý','kendi resmi',2,'hunharca gülmek',3,'hikaye anlatmak','1969-10-10','542 760 80 80','hayat üniversitesi','muhabbet arýyor','komik mi lan','skype tan private gülünür','2010-11-24',4);

	  select * from CV;
	  delete from CV where cv_id=1;
	  delete from CV where ref_cv_id=0;

	  select * from CV;
	  insert into CV values (2,'2014-06-20 14:25:02','2014-06-25 15:42:18',4);
	  insert into CV values (9,'2014-11-11 15:00:05',null,2);
	  
	  insert into CV_SKILLS values ('groovie',6),
      ('LINQ',6),
      ('Angular',6),
      ('Python',6),
      ('JQuery',6);
      insert into CV_SKILLS values ('java',6);

	  select * from STATUS;
	  update STATUS set message='kafa nereye biz oraya' where status_id=1;
	  update STATUS set to_twitter=1 where status_id=1;

	  select * from SHARE;
	  delete from SHARE where user_id=1;
	  
	  select * from COMMENT;
	  delete from COMMENT where status_id=2;
	  insert into COMMENT values (1,'acýsa da öldürmez.s','2014-12-22 13:30:42',9);

	  select * from THUMB_UP;
	  insert into THUMB_UP values (3,1,'2014-11-10',1);
	  insert into THUMB_UP values (2,1,'2014-11-07',2);

	  select * from CITY;
	  update CITY set city_name='Barcelona' where city_id=8;
	  
	  delete from CITY where country_id=1;

	  insert into CITY values (1,'ankara');
	  
	  /* SELECT */
	  /* SELECT FOR 1 TABLE */
	  
	  select first_name,middle_name,last_name from USERS where the_online=1;
	  
	  select * from PROFILE where education='ege üniversitesi';
	  
	  select user_id from EVENTMEMBER where event_id=2;
	  
	  /* SELECT FOR 2 TABLES */
	  
	  select email,relationship_details,picture 
	  from USERS,PROFILE
	  where user_name='CeNGiZ_6996' and USERS.user_id=PROFILE.user_id;
	  
	  select * 
	  from USERS,GROUPS 
	  where group_id=1 and USERS.user_id=GROUPS.group_leader_id;
	  
	  select * 
	  from PROFILE 
	  where user_id= (select user_id 
					  from USERS 
					  where with_relationship_id=1);
	  
	  select url 
	  from BOOKMARK 
	  where BOOKMARK.bookmark_category_id=(select bookmark_category_id 
										   from BOOKMARKCATEGORY 
										   where name='Gruplar');
										  
	  /* SELECT FOR 3 TABLES */
	  
	  select distinct skills 
	  from CV_SKILLS,CV
	  where CV.cv_id=CV_SKILLS.cv_id and CV.user_id=(select user_id 
													 from USERS 
													 where user_id=2);
													 
	  select first_name,middle_name,last_name,current_organization_id 
	  from USERS,PROFILE,CV 
	  where PROFILE.user_id=USERS.user_id and USERS.user_id=CV.user_id and CV.ref_cv_id=2;
	  
	  select COMMENT.message,thumbs_up 
	  from USERS,STATUS,COMMENT 
	  where USERS.user_id=STATUS.user_id and STATUS.status_id=COMMENT.status_id and USERS.user_name='Can48';
	  
