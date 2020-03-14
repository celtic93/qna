import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create('AnswersChannel', {
    connected: function() {
      var question_id = gon.question_id
      this.perform('follow', {id: question_id});
    },

    received: function(data) {
      if (gon.current_user_id != data.answer.user_id) {
        $('.answers').append(data.html)
      }
    }
  });
});
