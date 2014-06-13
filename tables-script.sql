    CREATE TABLE companydb.products (
      Id INT(11) NOT NULL,
      Version INT(11) DEFAULT NULL,
      InsertDate DATETIME DEFAULT NULL,
      Warrenty TINYINT(1) DEFAULT NULL,
      Price DECIMAL(19, 2) DEFAULT NULL,
      ModelCode INT(11) DEFAULT NULL,
      ModelColor VARCHAR(10) DEFAULT NULL,
      Model VARCHAR(255) DEFAULT NULL,
      ModelSize VARCHAR(10) DEFAULT NULL,
      InternalColor VARCHAR(10) DEFAULT NULL,
      InternalSize VARCHAR(10) DEFAULT NULL,
      PRIMARY KEY (Id)
    )
    ENGINE = INNODB
    CHARACTER SET utf8
    COLLATE utf8_general_ci
    COMMENT = 'Company''s Products';

    CREATE TABLE companydb.productsimages (
      Id INT(11) NOT NULL AUTO_INCREMENT,
      ProductId INT(11) DEFAULT NULL,
      Size VARCHAR(10) DEFAULT NULL,
      FileName VARCHAR(255) DEFAULT NULL,
      PRIMARY KEY (Id),
      CONSTRAINT FK_productsimages_products_Id FOREIGN KEY (ProductId)
        REFERENCES companydb.products(Id) ON DELETE RESTRICT ON UPDATE RESTRICT
    )
    ENGINE = INNODB
    AUTO_INCREMENT = 1
    CHARACTER SET utf8
    COLLATE utf8_general_ci
    COMMENT = 'Products'' Images';
    
    CREATE TABLE companydb.productsoptions (
      Id INT(11) NOT NULL AUTO_INCREMENT,
      ProductId INT(11) DEFAULT NULL,
      Type VARCHAR(255) DEFAULT NULL,
      `Option` VARCHAR(255) DEFAULT NULL,
      PRIMARY KEY (Id),
      CONSTRAINT FK_producstsoptions_products_Id FOREIGN KEY (ProductId)
        REFERENCES companydb.products(Id) ON DELETE RESTRICT ON UPDATE RESTRICT
    )
    ENGINE = INNODB
    AUTO_INCREMENT = 1
    CHARACTER SET utf8
    COLLATE utf8_general_ci;
