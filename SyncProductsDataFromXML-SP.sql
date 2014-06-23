CREATE DEFINER = 'root'@'localhost'
PROCEDURE companydb.SyncProductsDataFromXML(IN productsXml MEDIUMTEXT)
BEGIN
  
  DECLARE totalProducts INT;
  DECLARE productIndex INT;
  
  SET totalProducts = ExtractValue(productsXml, 'count(//export_management/product)');

  SET productIndex = 1;
  WHILE productIndex <= totalProducts DO
        -- Fetch the product's id first for later use in the related tables (images & options).
        SET @productId = CAST(ExtractValue(productsXml, 'export_management/product[$productIndex]/@id') AS UNSIGNED);

        INSERT INTO products(`Id`, `Version`, InsertDate, Warrenty, Price, ModelCode, Model, ModelColor, ModelSize, InternalColor, InternalSize)
        VALUES(
                @productId,
                ExtractValue(productsXml, 'export_management/product[$productIndex]/version'),
                ExtractValue(productsXml, 'export_management/product[$productIndex]/insert_date'),
                CASE WHEN (ExtractValue(productsXml, 'export_management/product[$productIndex]/warrenty')) <> 'false' THEN 1 ELSE 0 END,
                CAST(ExtractValue(productsXml, 'export_management/product[$productIndex]/price') as DECIMAL),
                ExtractValue(productsXml, 'export_management/product[$productIndex]/model/code'),
                ExtractValue(productsXml, 'export_management/product[$productIndex]/model/model'),
                ExtractValue(productsXml, 'export_management/product[$productIndex]/model/color'),
                ExtractValue(productsXml, 'export_management/product[$productIndex]/model/size'),
                ExtractValue(productsXml, 'export_management/product[$productIndex]/internal/color'),
                ExtractValue(productsXml, 'export_management/product[$productIndex]/internal/size')
              );
        -- Insert the images of the product
        SET @totalImages = ExtractValue(productsXml, 'count(//export_management/product[$productIndex]/images/image)');
        SET @imageIndex = 1;
        WHILE (@imageIndex <= @totalImages) DO
          INSERT INTO productsimages(ProductId, Size, FileName) VALUES(@productId, 'small', EXTRACTVALUE(productsXml, 'export_management/product[$productIndex]/images/image[$@imageIndex]/small'));
          SET @imageIndex = @imageIndex + 1;        
        END WHILE;
        
        -- Insert the standard options of the product
        SET @totalStandardOptions = ExtractValue(productsXml, 'count(//export_management/product[$productIndex]/options/s_option)');
        SET @standardOptionIndex = 1;
        WHILE (@standardOptionIndex <= @totalStandardOptions) DO
          INSERT INTO productsoptions(ProductId, `Type`, `Option`) VALUES(@productId, 'Standard Option', EXTRACTVALUE(productsXml, 'export_management/product[$productIndex]/options/s_option[$@standardOptionIndex]'));
          SET @standardOptionIndex = @standardOptionIndex + 1;
        END WHILE;


        -- Insert the extra options of the product
        SET @totalExtraOptions = ExtractValue(productsXml, 'count(//export_management/product[$productIndex]/options/extra_option)');
        SET @extraOptionIndex = 1;
        WHILE (@extraOptionIndex <= @totalExtraOptions) DO
          INSERT INTO productsoptions(ProductId, `Type`, `Option`) VALUES(@productId, 'Extra Option', EXTRACTVALUE(productsXml, 'export_management/product[$productIndex]/options/extra_option[$@extraOptionIndex]'));
          SET @extraOptionIndex = @extraOptionIndex + 1;        
        END WHILE;

        SET productIndex = productIndex + 1;
		
  END WHILE;
END
