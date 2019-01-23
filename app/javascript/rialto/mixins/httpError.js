export default {
    methods: {
        handleHttpError: function(error) {
            if (error == null) {
                return false;
            }
            if (error.status == 403) {
                alert('Your session has expired. Click OK to log back in.');
                window.location.assign('/');
            } else {
                alert('Oops. An error occurred.');
                console.error(error.statusText);
            }
            return true;
        },
    }
};
