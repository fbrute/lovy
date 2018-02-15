create table sounding2k18 (
  station_name     char(30),
  date             date,
  time             time  NOT  NULL,
  pressure         decimal(5,1)             NOT NULL,
  height           decimal(5,0)             NOT NULL,                     
  temp             decimal(3,1)             NOT NULL,                      
  dwpt             decimal(4,1)             NOT NULL,                      
  relhumidity      decimal(4,1)             NOT NULL,                     
  mixr             decimal(5,2)             NOT NULL,                      
  drct             decimal(3,0)             NOT NULL,                      
  snkt             decimal(3,0)             NOT NULL,                      
  thta             decimal(5,1)             NOT NULL,                      
  thte             decimal(5,1)             NOT NULL,                      
  thtv             decimal(5,1)             NOT NULL,                      
  id               int(11)                  NOT NULL      auto_increment  primary key,
  station_number   int(11)                  NOT NULL,                      
  inversion        varchar(45)              NULL,                      
  cape             decimal(9,2)             NOT NULL,                      
  cins             decimal(9,2)             NOT NULL,                      
  conv_inhib       decimal(9,2)             NOT NULL,                      
  cape_virt        decimal(9,2)             NOT NULL
)              
