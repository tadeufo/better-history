class BH.Views.TagsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'tags_view with_controls'

  template: BH.Templates['tags']

  events:
    'click .delete_all': 'onDeleteTagsClicked'

  initialize: ->
    @chromeAPI = chrome
    @collection.on 'reset', @onTagsLoaded, @

  pageTitle: ->
    @t('collections_title')

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.append html
    @

  onTagsLoaded: ->
    tag_count = @t 'number_of_collections', [@collection.length]
    @$('.tag_count').text tag_count
    @renderTags()

  renderTags: ->
    @tagsListView.remove() if @tagsListView
    @tagsListView = new BH.Views.TagsListView
      collection: @collection
    @$('.content').html @tagsListView.render().el

  onDeleteTagsClicked: (ev) ->
    @promptToDeleteTags()

  promptToDeleteTags: ->
    promptMessage = @t('confirm_delete_all_collections')
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      @collection.destroy()
      @collection.fetch()
      @promptView.close()
    else
      @promptView.close()

  getI18nValues: ->
    properties = @t ['collections_title', 'search_input_placeholder_text', 'delete_all_collections']
    properties.i18n_number_of_collections = @t 'number_of_collections', [5]
    properties
