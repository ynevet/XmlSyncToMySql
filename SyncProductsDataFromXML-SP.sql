    CREATE DEFINER = 'root'@'localhost'
    PROCEDURE companydb.SyncProductsDataFromXML(IN productsXml TEXT)
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
            SET @totalImages = ExtractValue(productsXml, 'count(//export_management/product[$productIndex]/images)');
            SET @imageIndex = 1;
            WHILE (@imageIndex <= @totalImages) DO
              INSERT INTO productsimages(ProductId, Size, FileName) VALUES(@productId, 'small', EXTRACTVALUE(productsXml, 'export_management/product/images/image[$@imageIndex]/small'));
              SET @imageIndex = @imageIndex + 1;        
            END WHILE;
            
            -- Insert the options of the product
            SET @totalOptions = ExtractValue(productsXml, 'count(//export_management/product[$productIndex]/options)');
            SET @optionIndex = 1;
            WHILE (@optionIndex <= @totalOptions) DO
              INSERT INTO productsoptions(ProductId, `Type`, `Option`) VALUES(@productId, EXTRACTVALUE(productsXml, 'standard_option'), EXTRACTVALUE(productsXml, 'export_management/product/options[$@optionIndex]/standard_option'));
              INSERT INTO productsoptions(ProductId, `Type`, `Option`) VALUES(@productId, EXTRACTVALUE(productsXml, 'extra_option'), EXTRACTVALUE(productsXml, 'export_management/product/options[$@optionIndex]/extra_option'));
              SET @optionIndex = @optionIndex + 1;        
            END WHILE;
    
            SET productIndex = productIndex + 1;
    		
      END WHILE;
    END
