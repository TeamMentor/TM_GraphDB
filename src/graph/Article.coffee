Import_Service   = require '../services/Import-Service'
Wiki_Service     = require '../services/Wiki-Service'
Markdown_Service = require '../services/Markdown-Service'

class Article

  constructor: (importService)->
    @.importService  = importService || new Import_Service('tm-uno')

  ids: (callback)=>
    @.importService.find_Using_Is 'Article', (articles_Ids)=>
      callback articles_Ids

  graph_Data: (article_Id, callback)=>
    @.importService.get_Subject_Data article_Id, callback

  file_Path: (article_Id, callback)=>
    log article_Id
    @.graph_Data article_Id, (article_Data)=>
      guid = article_Data.guid
      @.importService.content.json_Files (jsonFiles)=>
        path = jsonFile for jsonFile in jsonFiles when jsonFile.contains guid
        callback path

  raw_Data: (article_Id, callback)=>
    @.file_Path article_Id, (path)=>
      callback path.load_Json()

  raw_Content: (article_Id, callback)=>
    @.file_Path article_Id, (path)=>
      data = path.load_Json()
      callback data.TeamMentor_Article.Content.first().Data.first()

  content_Type: (article_Id, callback)=>
    @.raw_Data article_Id, (data)=>
      callback data.TeamMentor_Article.Content.first()['$'].DataType

  html: (article_Id, callback)=>
    @.raw_Data article_Id, (data)=>
      content = data.TeamMentor_Article.Content.first()
      dataType    = content['$'].DataType
      raw_Content = content.Data.first()
      switch (dataType.lower())
        when 'wikitext'
          html = new Wiki_Service().to_Html raw_Content
        when 'markdown'
          html = new Markdown_Service().to_Html raw_Content
        else
          html = raw_Content

      callback html



module.exports = Article