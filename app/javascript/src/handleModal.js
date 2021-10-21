export default () => {
  document.addEventListener('turbolinks:load', () => {
    const eventsNewModalTrigger = document.getElementById('show-events-new-modal')

    if (eventsNewModalTrigger === null) return false;

    const html = document.querySelector('html');
    const body = document.querySelector('body');

    if (eventsNewModalTrigger) {
      const eventsNewModal = document.getElementById('events-new-modal')

      eventsNewModalTrigger.addEventListener('click', () => {
        eventsNewModal.classList.add('is-active');
        html.classList.add('is-clipped');
        body.classList.add('mr-4');
      });

      const eventsNewModalCloseButton = eventsNewModal.querySelector('#close-events-new-modal');
      eventsNewModalCloseButton.addEventListener('click', () => {
        eventsNewModal.classList.remove('is-active');
        html.classList.remove('is-clipped');
        body.classList.remove('mr-4');
      });

      const validation_errors = document.getElementsByClassName('field_with_errors')
      if (location.pathname === '/events' && validation_errors.length) {
        eventsNewModal.classList.add('is-active');
        html.classList.add('is-clipped');
        body.classList.add('mr-4');
      }
    }
  });
}
