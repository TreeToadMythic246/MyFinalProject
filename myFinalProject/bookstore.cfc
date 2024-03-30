component {
    function obtainSearchResults(searchMe, genre){
        if(searchme.len() != 0){
        var qs = new query(datasource=application.dsource)
        qs.setSql("SELECT * from books INNER JOIN publishers ON books.publisherid=publishers.publisher WHERE title like :searchMe OR isbn13 like :searchMe");
        qs.addParam(name="searchme",value="%#trim(arguments.searchme)#%");
        qs.addParam(name="isbn13", value="#searchme#");
        return qs.execute().getResult();
        } else if(genre.len() != 0){
            var qs = new query(datasource=application.dsource)
            qs.setSql("
            SELECT * from books 
            INNER JOIN genresToBooks
            on books.isbn13 = genresToBooks.bookid 
            inner join publishers
            on books.publisherid=publishers.publisher
            where genreid = :genre ");
            qs.addParam(name="genre", value=trim(arguments.genre));
            return qs.execute().getResult();
            
        }
    }

    function genresInStock(){
        var qs = new query (datasource=application.dsource);
        qs.setSql("select distinct name, genreid from genrestobooks
        inner join genres on genres.id = genrestobooks.genreid
        order by genres.name");
        return qs.execute().getResult();
    }

    function resultsHeader(searchme, genre){
        if(searchme.len() > 0){
            return 'Keyword: #searchme#';
        } elseif (genre.len() > 0) {
            return 'Genre: #obtainGenreNameById(arguments.genre)#';
        }
    }

    function obtainGenreNameById(genreid){
        var qs = new query(datasource=application.dsource);
        qs.setSql("
        SELECT name from genres where id=:genreid");
        qs.addParam(name="genreid", value=arguments.genreid);
        return qs.execute().getResult().name;
    }

}