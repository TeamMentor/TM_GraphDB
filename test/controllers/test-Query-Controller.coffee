expect          = require('chai'     ).expect
supertest       = require('supertest')
Query_Controller = require('./../../src/controllers/Query-Controller')
Server          = require('./../../src/Server')

describe 'controllers | test-Query-Controller |', ->
  describe 'core |', ->
    it 'check ctor',->
      queryController = new Query_Controller()
      expect(Query_Controller      ).to.be.an('function')
      expect(queryController       ).to.be.an('object')
      expect(queryController.server).to.be.undefined

      server = new Server()
      queryController = new Query_Controller(server)
      expect(queryController.server).to.equal(server)


  describe 'routes |', ->
    server         = new Server()
    app            = server.app
    queryController = new Query_Controller(server).add_Routes()

    it 'add_Routes', ->
      expect(queryController.server.routes()).to.contain('/data/:dataId/:queryId')

    it '/data/:dataId/:queryId' , (done)->

      supertest(app).get('/data/v0.1/simple')
        .expect(200)
        .expect('Content-Type', /json/)
        .end (error, response) ->
          expect(error).to.be.null
          graph = JSON.parse(response.text)
          expect(graph       ).to.be.an('object')
          expect(graph.nodes).to.be.an('array')
          expect(graph.edges).to.be.an('array')
          expect(graph.nodes.size()).to.equal(8)
          expect(graph.edges.size()).to.equal(8)
          expect(graph.nodes.first()).to.deep.equal({'id': 'a'})
          expect(graph.edges.first()).to.deep.equal({from:'a' , to: 'c1'})

          done()