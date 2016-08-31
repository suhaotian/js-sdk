class Moltin

  "use strict"

  options:
    clientId: ''
    clientSecret: ''
    auth: {}
    url: 'api.molt.in'
    port: '443'
    protocol: 'https'
    version: 'v2'
    debug: false
    currency: false
    language: false
    methods: ['GET', 'POST', 'PUT', 'DELETE']
    notice: (type, msg) ->

      console.log type + ": " + msg


  constructor: (overrides) ->


    @Storage = new Storage
    @Helper = new Helper
    @Ajax = new Ajax

    @options = @Helper.Merge @options, overrides
    @Address       = new Address @
    @Brand         = new Brand @
    @Cart          = new Cart @
    @Category      = new Category @
    @Checkout      = new Checkout @
    @Collection    = new Collection @
    @Currency      = new Currency @
    @Entry         = new Entry @
    @Gateway       = new Gateway @
    @Language      = new Language @
    @Order         = new Order @
    @Product       = new Product @
    @Shipping      = new Shipping @
    @Tax           = new Tax @


    if @Storage.get 'mcurrency'
      @options.currency = @Storage.get 'mcurrency'

    if @Storage.get 'mlanguage'
      @options.language = @Storage.get 'mlanguage'


  Error: (response) ->

    msg = ''

    if typeof response.errors != 'undefind'
      msg += v+'<br />' for k,v of response.errors
    else
      msg = response.error

    return @options.notice 'Error', msg

  Authenticate: (callback, error)->

    # Throws an error when the client_id isn't set
    if @options.clientId <= 0
      throw new Error("A client ID must be provided");
    else
      # Make a request to the API







    return @

  Request: (uri, method = 'GET', data = null, callback, error) ->

    _data    = {}
    _headers =
      'Content-Type': 'application/x-www-form-urlencoded'
      'Authorization': @options.auth.token

    if @options.auth.token == null
      if typeof error == 'function'
        error 'error', 'You much authenticate first', 401

    if Date.now() >= @options.auth.expires
      @Authenticate null, error

    if not @InArray method, @options.methods
      if typeof error == 'function'
        error 'error', 'Invalid request method ('+method+')', 400

    if @options.currency
      _headers['X-Currency'] = @options.currency

    if @options.language
      _headers['X-Language'] = @options.language

    @Ajax
      method: method
      path: uri
      data: data
      async: if typeof callback == 'function' then true else false
      headers: _headers
      success: (r, c, e) =>
        if typeof callback == 'function'
          callback r.result, if typeof r.pagination != 'undefined' then r.pagination else null
        else
          _data = r
      error: (r, c, e) =>
        if r.status is false
          if typeof error == 'function'
            error 'error', ( if typeof r.errors != 'undefined' then r.errors else r.error ), c
          else
            @Error ( if typeof r.errors != 'undefined' then r.errors else r.error )
        _data = r;

    if typeof callback == 'undefined'
      return _data.result
