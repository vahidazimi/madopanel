<footer class="pc-footer">
    <div class="footer-wrapper container-fluid">
        <div class="row">
            <div class="col my-1">

            </div>
            <div class="col-auto my-1">
                <ul class="list-inline footer-link mb-0">
                    <li class="list-inline-item"><a href="{{route('document')}}">API</a></li>
                    <li class="list-inline-item"><a href="https://github.com/vahidazimi/madopanel/blob/master/README-EN.md#supporting-us-hearts">Supporting us</a></li>
                    <li class="list-inline-item"><a href="https://github.com/vahidazimi/madopanel/">GitHub</a></li>
                </ul>
            </div>
        </div>
    </div>
</footer>

<!-- [Page Specific JS] start -->
<script src="/assets/js/plugins/apexcharts.min.js"></script>

<!-- [Page Specific JS] end -->
<!-- Required Js -->
<script src="/assets/js/plugins/popper.min.js"></script>
<script src="/assets/js/plugins/simplebar.min.js"></script>
<script src="/assets/js/plugins/bootstrap.min.js"></script>
<script src="/assets/js/fonts/custom-font.js"></script>
@php $selectedLanguage = env('APP_MODE', 'light'); @endphp
@if($selectedLanguage=='light')
    <script src="/assets/js/config.js?v=3.8.0"></script>
@elseif($selectedLanguage=='night')
    <script src="/assets/js/config-night.js?v=3.8.0"></script>
@endif
<script src="/assets/js/pcoded.js"></script>
<script src="/assets/js/plugins/feather.min.js"></script>
<!-- [Page Specific JS] start -->
<script src="/assets/js/plugins/simple-datatables-en-us.js"></script>
<script src="/assets/js/clipboard.min.js"></script>
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script src="/assets/js/persian-date.js"></script>
<script src="/assets/js/persian-datepicker.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $(".example1").persianDatepicker({
            initialValueType: 'persian',
            initialValue: false,
            observer: false,
            format: 'YYYY-MM-DD',
            altField: '.observer-example-alt',
            autoClose: true,
        });
    });
</script>
<script>

    // basic example
    new ClipboardJS('[data-clipboard=true]').html()('success', function (e) {
        e.clearSelection();
        alert('Copied!');
    });
</script>
<script>
    const dataTable = new simpleDatatables.DataTable('#pc-dt-simple', {
        sortable: true,
        perPage: 25
    });
</script>
<script type="text/javascript">
    const status_traffic = document.getElementById("status_traffic");
    status_traffic.addEventListener("change", function() {
        if (status_traffic.checked) {
            status_traffic.value = "active";
        } else {
            status_traffic.value = "deactive";
        }
    });
</script>
<script type="text/javascript">
    const status_multiuser = document.getElementById("status_multiuser");
    status_multiuser.addEventListener("change", function() {
        if (status_multiuser.checked) {
            status_multiuser.value = "active";
        } else {
            status_multiuser.value = "deactive";
        }
    });
</script>

<script type="text/javascript">
    const status_day = document.getElementById("status_day");
    status_day.addEventListener("change", function() {
        if (status_day.checked) {
            status_day.value = "active";
        } else {
            status_day.value = "deactive";
        }
    });
</script>
<!-- [Page Specific JS] end -->
</body>
<!-- [Body] end -->

</html>
