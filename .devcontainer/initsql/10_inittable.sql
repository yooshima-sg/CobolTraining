create table if not exists userinfo (
    userid      char(5) primary key,
    username    char(32) not null,
    userage     char(5) not null
);


insert into userinfo(userid, username, userage) values 
('0001', 'Giken Taro', '0042'),
('0002', 'Giken Hanako', '0032'),
('0003', 'Giken Saburo', '0022')
;
