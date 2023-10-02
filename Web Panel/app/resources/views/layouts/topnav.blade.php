<!-- [ Sidebar Menu ] start -->
<nav class="pc-sidebar">
    <div class="navbar-wrapper">
        <div class="m-header">
            <a href="#" class="b-brand text-primary">
                <!-- ========   Change your logo from here   ============ -->
                <img src="/assets/images/xlogo.png" alt="MadoPanel" style="width:50px"/>
                <span class="badge bg-light-success rounded-pill ms-2 theme-version" style="font-size: 13px;"></span>
            </a>
        </div>
        <div class="navbar-content">
            <div class="card pc-user-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <img src="/assets/images/user/avatar-1.jpg" alt="user-image" class="user-avtar wid-45 rounded-circle" />
                        </div>
                        <div class="flex-grow-1 ms-3 me-2">
                            <h6 class="mb-0">Admin</h6>
                        </div>
                        <a class="btn btn-icon btn-link-secondary avtar" data-bs-toggle="collapse" href="#pc_sidebar_userlink">
                            <svg class="pc-icon">
                                <use xlink:href="#custom-sort-outline"></use>
                            </svg>
                        </a>
                    </div>
                    <div class="collapse pc-user-links" id="pc_sidebar_userlink">
                        <div class="pt-3">
                            <a href="{{route('setting')}}">
                                <i class="ti ti-settings"></i>
                                <span>{{__('menu-setting')}}</span>
                            </a>
                            <a href="{{route('user.logout')}}">
                                <i class="ti ti-power"></i>
                                <span>{{__('menu-logout')}}</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <ul class="pc-navbar">
                <li class="pc-item pc-caption">
                    <label>SSH Direct + TLS + Dropbear</label>
                    <i class="ti ti-dashboard"></i>
                </li>
                <li class="pc-item">
                    <a href="{{route('dashboard')}}" class="pc-link">
                        <i data-feather="airplay"></i>
                        <span class="pc-mtext">{{__('menu-dashboard')}}</span>
                    </a>
                </li>

                <li class="pc-item">
                    <a href="{{route('users')}}" class="pc-link">
                        <i data-feather="users"></i>
                        <span class="pc-mtext">{{__('menu-users')}}</span>
                    </a>
                </li>

                <li class="pc-item">
                    <a href="{{route('online')}}" class="pc-link">
            <span class="pc-micon">
              <svg class="pc-icon">
                <use xlink:href="#custom-story"></use>
              </svg>
            </span>
                        <span class="pc-mtext">{{__('menu-online')}}</span>
                    </a>
                </li>
                <li class="pc-item pc-caption">
                    <label>{{__('menu-other')}}</label>
                    <i class="ti ti-chart-arcs"></i>
                </li>
                <li class="pc-item">
                    <a href="{{route('filtering')}}" class="pc-link">
                        <i data-feather="target"></i>
                        <span class="pc-mtext">{{__('menu-filtering')}}</span>
                    </a>
                </li>
                <li class="pc-item">
                    <a href="{{route('admins')}}" class="pc-link">
                        <i data-feather="users"></i>
                        <span class="pc-mtext">{{__('menu-manager')}}</span>
                    </a>
                </li>

            </ul>
        </div>
    </div>
</nav>
<!-- [ Sidebar Menu ] end -->
<!-- [ Header Topbar ] start -->
<header class="pc-header">
    <div class="header-wrapper"> <!-- [Mobile Media Block] start -->
        <div class="me-auto pc-mob-drp">
            <ul class="list-unstyled">
                <!-- ======= Menu collapse Icon ===== -->
                <li class="pc-h-item pc-sidebar-collapse">
                    <a href="#" class="pc-head-link ms-0" id="sidebar-hide">
                        <i class="ti ti-menu-2"></i>
                    </a>
                </li>
                <li class="pc-h-item pc-sidebar-popup">
                    <a href="#" class="pc-head-link ms-0" id="mobile-collapse">
                        <i class="ti ti-menu-2"></i>
                    </a>
                </li>
            </ul>
        </div>
        <div class="ms-auto">
            <ul class="list-unstyled">
                <li class="dropdown pc-h-item">
                    <a href="https://github.com/vahidazimi/madopanel" target="_blank">
                    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/vahidazimi/madopanel?style=social&link=left">
                    </a>
                </li>
                <li class="dropdown pc-h-item">
                    <a href="https://plisio.net/donate/KL6W5z8k" target="_blank"><span class="badge bg-light-primary rounded-pill f-12"><i class="fas fa-donate"></i>&nbsp;{{__('donate')}}</span></a>
                </li>
                <li class="dropdown pc-h-item">
                    <a class="pc-head-link dropdown-toggle arrow-none me-0" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                        <svg class="pc-icon">
                            <use xlink:href="#custom-sun-1"></use>
                        </svg>
                    </a>
                    <div class="dropdown-menu dropdown-menu-end pc-h-dropdown" style="">
                        <a href="{{ route('mod', ['name' => 'night']) }}" class="dropdown-item" onclick="layout_change('dark')">
                            <svg class="pc-icon">
                                <use xlink:href="#custom-moon"></use>
                            </svg>
                            <span>Dark</span>
                        </a>
                        <a href="{{ route('mod', ['name' => 'light']) }}" class="dropdown-item" onclick="layout_change('light')">
                            <svg class="pc-icon">
                                <use xlink:href="#custom-sun-1"></use>
                            </svg>
                            <span>Light</span>
                        </a>
                    </div>
                </li>

                <li class="dropdown pc-h-item">
                    <a class="pc-head-link dropdown-toggle arrow-none me-0" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                        <i class="ti ti-language"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-end pc-h-dropdown" style="">
                        <a href="{{ route('lang', ['name' => 'fa']) }}" class="dropdown-item">
                            <i class="fas fa-language"></i>
                            <span>فارسی</span>
                        </a>
                        <a href="{{ route('lang', ['name' => 'en']) }}" class="dropdown-item">
                            <i class="fas fa-language"></i>
                            <span>English</span>
                        </a>
                    </div>
                </li>

            </ul>
        </div>

    </div>
</header>
<!-- [ Header ] end -->
