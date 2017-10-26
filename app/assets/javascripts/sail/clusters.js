(function () {
    "use strict";
    $(document).ready(function() {
        if ($("#controller-picker").hasClass("clusters-controller")) {
            setupClustersPage();
        }
    });

    function setupClustersPage () {
        $("#model").change(getColumns);
    }

    function getColumns () {
        $.ajax({
           url: '/sail/clusters/columns',
           data: { model: $(this).val() },
           method: 'GET',
           success: renderColumns
        });

        function renderColumns (data) {
            var html = "<label for='label'>Data label</label><select name='label' id='label'>";

            $.each(data, function (index, element) {
                html += "<option value='" + element + "'>" + element + "</option>";
            });

            html += "</select>";
            $("#column-for-labels").html(html);
        }
    }
})();
