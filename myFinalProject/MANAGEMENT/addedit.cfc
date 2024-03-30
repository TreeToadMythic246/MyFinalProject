component {

    function processForms( required struct formData ){
        if( formData.keyExists("isbn13") && formData.isbn13.len() == 13 && formData.keyExists("title") && formData.title.len() > 0 ) {
            if(formdata.keyExists("uploadimage") && formData.uploadimage.len() > 0){
                arguments.formData.image = uploadBookCover();
            } 

            var qs = new query(datasource = application.dsource);

            qs.setSql( 'IF NOT EXISTS( SELECT * FROM books WHERE isbn13=:isbn13)
                INSERT INTO books (isbn13,title) VALUES ( :isbn13, :title );
                UPDATE books SET
                    title=:title,
                    weight=:weight,
                    publisherId=:publisher,
                    pages=:pages,
                    year=:year,
                    image=:image,
                    Description=:description
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
                name = "publisher",
                cfsqltype = 'CF_SQL_NVARCHAR',
                value = trim(formData.publisher),
                null = formData.publisher.len() == 0
            );
            qs.addParam(
                name = "image",
                cfsqltype = "CF_SQL_NVARCHAR",
                value = trim(formData.image),
                null = trim(formData.image).len()==0
            );
            qs.addParam(
                name = 'description',
                cfsqltype = 'CF_SQL_NVARCHAR',
                value = trim(formData.description),
                null = trim(formData.description).len() == 0
            );
            qs.execute();

            if(formData.keyExists("genre")){
                deleteAllBookGenres(formData.isbn13);
                
                formData.genre.listToArray().each(function(item){
                    insertGenre(item, formData.isbn13);
                });
            }
        }   
    }

    function sideNavBooks( qTerm ){
        if(qTerm.len() ==0){
            return queryNew("title");
        } else {     
            var qs = new query(datasource=application.dsource);
            qs.setSql("select * from books where title like :qterm order by title");
            qs.addParam(name="qTerm",value="%#qterm#%");
            return qs.execute().getResult();
        }
    }
    function bookDetails(required string isbn13){
        var qs = new query(datasource=application.dsource);
        qs.setSql("select * from books where isbn13=:isbn13 order by title");
        qs.addParam(
            name = "isbn13",
            cfsqltype = "CF_SQL_NVARCHAR",
            value = trim(arguments.isbn13)
        );
        return qs.execute().getResult();
    }
    function allPublishers(isbn13){
        var qs = new query(datasource=application.dsource);
        qs.setSql(" SELECT * from publishers order by name")
        return qs.execute().getResult();
    }
    
    function uploadBookCover(){
        var imageData = fileUpload(
            expandPath("../images/"),
            "uploadimage",
            "*",
            "makeUnique"
        );
        writeDump(imageData);
        return imageData.serverFile;
    }   
    function allGenres(isbn13){
        var qs = new query(datasource=application.dsource);
        qs.setSql("select * from genres order by name");
        return qs.execute().getResult();
    }

    function insertGenre(genreId, bookId) {
        var qs = new query(datasource=application.dsource);
        qs.setSql("insert into genresToBooks (bookid, genreid) VALUES (:bookid, :genreid)");
        qs.addParam(name="bookid", value=arguments.bookId);
        qs.addParam(name="genreid", value=arguments.genreId);
        qs.execute();
      }
    

    function deleteAllBookGenres(bookId){
        var qs = new query(datasource=application.dsource);
        qs.setSql("delete from genresToBooks WHERE bookId=:bookid");
        qs.addParam(name="bookid", value=arguments.bookId);
        qs.execute();
    }

    function bookGenres(bookId){
        var qs = new query(datasource=application.dsource);
        qs.setSql("select * from genresToBooks where bookid=:bookid");
        qs.addParam(name="bookId", value=arguments.bookid);
        return qs.execute().getResult();
    }

    function allContent(contentId){
        var qs = new query(datasource=application.dsource);
        qs.setSql("select * from content where contentId =:contentId");
        qs.addParam(name="contentId", value=arguments.contentId);
        return qs.execute().getResult();
    }
 

}