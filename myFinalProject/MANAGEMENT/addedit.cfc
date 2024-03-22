component {
    function processForms( required struct formData ){
        if( formData.keyExists("isbn13") && formData.isbn13.len() == 13 && formData.keyExists("title") && formData.title.len() > 0 ) {
            
            if(formData.keyExists("image") && formData.image.len()){
                arguments.formData.image = uploadBookCover();
            }
            writeDump(formData);

            var qs = new query( datasource = application.dsource );
            qs.setSql( 'IF NOT EXISTS( SELECT * FROM books WHERE isbn13=:isbn13)
            INSERT INTO books (isbn13,title) VALUES ( :isbn13, :title );
            UPDATE books SET
                title=:title,
                weight=:weight,
                pages=:pages,
                year=:year,
                publisherId=:publisherId,
                image=:image
            WHERE isbn13=:isbn13

            ');
            qs.addParam(
                name = "isbn13",
                cfsqltype = "CF_SQL_NVARCHAR",
                value = trim(formData.isbn13),
                null=formData.isbn13.len()!=13
            );
            qs.addParam(
                name = "title",
                cfsqltype = "CF_SQL_NVARCHAR",
                value = trim(formData.title),
                null=formData.title.len()==0
            );
            qs.addParam(
                name = "year",
                cfsqltype = "CF_SQL_INTEGER",
                value = trim(formData.year),
                null=!isValid("numeric",formData.year)  
            );
            qs.addParam(
                name = "pages",
                cfsqltype = "CF_SQL_INTEGER",
                value = trim(formData.pages),
                null=!isValid("numeric",formData.pages)
            );
            qs.addParam(
                name = "weight",
                cfsqltype = "CF_SQL_NUMERIC",
                value = trim(formData.weight),
                null=!isValid("numeric",formData.weight)
            );
            qs.addParam(
                name = "publisherId",
                cfsqltype = "CF_SQL_NVARCHAR",
                value = trim(formData.publisher),
                null=formData.publisher.len()==0
            );
            qs.addParam(
                name="image",
                cfsqltype="CF_SQL_NVARCHAR",
                value=formData.image
            );

            qs.execute();
        }
    }

    function sideNavBooks(){
        var qs = new query(datasource=application.dsource);
        qs.setSql("select * from books");
        return qs.execute().getResult();
    }

    function allPublishers(){
        var qs = new query(datasource=application.dsource);
        qs.setSql("select * from publishers order by name")
        return qs.execute().getResult();
    }
    function bookDetails(required string isbn13){
        var qs = new query(datasource=application.dsource);
        qs.setSql("select * from books where isbn13=:isbn13");
        qs.addParam(
            name = "isbn13",
            cfsqltype = "CF_SQL_NVARCHAR",
            value = trim(arguments.isbn13)
        );
        return qs.execute().getResult();
    }
    function uploadBookCover(){
        var imageData = fileUpload(expandPath("../images/"),
            "image",
            "*",
            "makeUnique"
        );
        writeDump(imageData);
        return imageData.serverFile;
    }
       
}