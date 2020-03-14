import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create('CommentsChannel', {
    connected: function() {
      var question_id = gon.question_id
      this.perform('follow', {id: question_id});
    },

    received: function(data) {
      if (gon.current_user_id != data.comment.user_id) {
        var commentedId = data.comment.commentable_id
        if (data.comment.commentable_type === 'Answer' ) {
          $('.comments-answer-' + commentedId).append(data.html);
        } else if (data.comment.commentable_type === 'Question' ){
          $('.comments-question-' + commentedId).append(data.html);
        }
      }
    }
  });
});
