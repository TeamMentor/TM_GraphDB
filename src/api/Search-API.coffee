#require 'fluentnode'
Swagger_GraphDB       = require './base-classes/Swagger-GraphDB'
#Search_Text_Service   = require '../services/text-search/Search-Text-Service'
Search                = require '../services/search/Search'
Search_Text_Mappings  = require '../services/search/Search-Text-Mappings'


class Search_API extends Swagger_GraphDB
    constructor: (options)->
      @.options        = options || {}
      @.options.area   = 'search'
      @.search         = new Search()
      super(@.options)

    all_words: (req,res)=>
      new Search_Text_Mappings().search_Words (words)->
        res.send words

    article_titles: (req,res)=>                                             # used by TM_Website.Angular-Controller.get_Search_Auto_Complete
      @.using_Search_Service res, 'search_article_titles.json', (send)->
        @.article_Titles send

#    article_summaries: (req,res)=>
#      @.using_Search_Service res, 'search_article_summaries.json', (send)->
#        @.article_Summaries send

    query_titles: (req,res)=>                                               # used by TM_Website.Angular-Controller.get_Search_Auto_Complete
      @.using_Search_Service res, 'search_query_titles.json', (send)->
        @.query_Titles send

    query_from_text_search: (req,res)=>
      text = req.params?.text || ''
      @.search.map_Search_Results_For_Text text, (query_Id)->
        res.json query_Id




    word_score: (req,res)=>
      word = req.params?.word?.lower() || ''
      new Search().search_Text.word_Score word, (data)->
        res.send data

    words_score: (req,res)=>
      words = req.params?.words || ''
      new Search().search_Text.words_Score words, (data)->
        res.send data


    add_Methods: ()=>
      @.add_Get_Method 'all_words'
      @.add_Get_Method 'article_titles'
#      @.add_Get_Method 'article_summaries'
      @.add_Get_Method 'query_titles'
      @.add_Get_Method 'query_from_text_search', ['text',]

      @.add_Get_Method 'word_score', ['word']
      @.add_Get_Method 'words_score', ['words']
      @


module.exports = Search_API
