component {

    /**
     * Processes form data to insert or update content.
     * 
     */
    function processForms(required struct formData) {
        if (formData.keyExists("contentid") && formData.keyExists("title") && formData.title.len() > 0) {
            var qs = new query(datasource = application.dsource);
            qs.setSql("IF NOT EXISTS(SELECT * FROM content WHERE contentid = :contentid)
                    INSERT INTO content (contentid, title) VALUES (:contentid, :title);
                    UPDATE content SET
                    title = :title,
                    description = :description
                WHERE contentid = :contentid
            ");
            qs.addParam(name = "contentid", cfsqltype = "CF_SQL_NVARCHAR", value = trim(formData.contentid), null = formData.id.len() != 35);
            qs.addParam(name = "title", cfsqltype = "CF_SQL_NVARCHAR", value = trim(formData.title), null = formData.title.len() == 0);
            qs.addParam(name = "description", cfsqltype = "CF_SQL_NVARCHAR", value = trim(formData.description), null = trim(formData.description).len() == 0);
            qs.execute();
        }
    }

    /**
     * Retrieves content details by contentid.
     * 
     */
    function contentDetails(contentid) {
        var qs = new query(datasource = application.dsource);
        qs.setSql("SELECT * FROM content WHERE contentid = :contentid");
        qs.addParam(name = "contentid", cfsqltype = "CF_SQL_NVARCHAR", value = arguments.contentid);
        return qs.execute().getResult();
    }

    /**
     * Retrieves all content.
     * 
     */
    function allContents() {
        var qs = new query(datasource = application.dsource);
        qs.setSql("SELECT * FROM content ORDER BY title");
        return qs.execute().getResult();
    }

    /**
     * Retrieves content titles for navigation.
     * 
     */
    function sideContentNav(qTerm) {
        if (qTerm.len() == 0) {
            return queryNew("title");
        } else {
            var qs = new query(datasource = application.dsource);
            qs.setSql("SELECT * FROM content WHERE title LIKE :qterm ORDER BY title");
            qs.addParam(name = "qTerm", value = "%#qterm#%");
            return qs.execute().getResult();
        }
    }

    /**
     * Inserts new content.
     * 
     */
    function insertContent(contentid) {
        var qs = new query(datasource = application.dsource);
        qs.setSql("INSERT INTO content (contentid) VALUES (:contentid)");
        qs.addParam(name = "contentid", value = arguments.contentid);
        qs.execute();
    }

    /**
     * Retrieves content by contentid.
     * 
     */
    function contentContents(contentid) {
        var qs = new query(datasource = application.dsource);
        qs.setSql("SELECT * FROM content WHERE contentid = :contentid");
        qs.addParam(name = "contentid", value = arguments.contentid);
        return qs.execute().getResult();
    }
}
