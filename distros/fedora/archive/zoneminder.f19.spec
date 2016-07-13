%define cambrev 0.931
%define moorev 1.3.2
%define jscrev 1.0

%define zmuid $(id -un)
%define zmgid $(id -gn)
%define zmuid_final apache
%define zmgid_final apache

%global _hardened_build 1

### Delete the lines below to build with ffmpeg and/or x10
%define _without_ffmpeg 1
%define _without_x10 1

Name:       zoneminder
Version:    1.27
Release:    1%{?dist}
Summary:    A camera monitoring and analysis tool
Group:      System Environment/Daemons
# jscalendar is LGPL (any version):  http://www.dynarch.com/projects/calendar/
# Mootools is inder the MIT license: http://mootools.net/
License:    GPLv2+ and LGPLv2+ and MIT 
URL:        http://www.zoneminder.com/

#Source:     https://github.com/ZoneMinder/ZoneMinder/archive/v%{version}.tar.gz
Source:     ZoneMinder-%{version}.tar.gz
Source2:    jscalendar-%{jscrev}.zip
#Source2:    http://downloads.sourceforge.net/jscalendar/jscalendar-%{jscrev}.zip

# Need to unravel the proper mootools files to grab from upstream, since the
# number of them keeps multiplying.  In the meantime, rely on the ones bundled
# with zoneminder.  As these are javascript, there is no guideline violation
# here.
#Source3:    http://mootools.net/download/get/mootools-core-%{moorev}-full-compat-yc.js

Patch1:     zoneminder-1.24.3-runlevel.patch
Patch2:     zoneminder-1.26.0-defaults.patch
%{?_without_ffmpeg:Patch3:	zoneminder-1.26.3-noffmpeg.patch}

BuildRequires:  automake gnutls-devel systemd-units
BuildRequires:  libtool bzip2-devel
BuildRequires:  community-mysql-devel pcre-devel libjpeg-turbo-devel
BuildRequires:  perl(Archive::Tar) perl(Archive::Zip)
BuildRequires:  perl(Date::Manip) perl(DBD::mysql)
BuildRequires:  perl(ExtUtils::MakeMaker) perl(LWP::UserAgent::Determined)
BuildRequires:  perl(MIME::Entity) perl(MIME::Lite)
BuildRequires:  perl(PHP::Serialization) perl(Sys::Mmap)
BuildRequires:  perl(Time::HiRes) perl(Net::SFTP::Foreign)
BuildRequires:  perl(Expect) perl(Sys::Syslog)
BuildRequires:  gcc gcc-c++ vlc-devel libcurl-devel
BuildRequires:  autoconf autoconf-archive polkit-devel
%{!?_without_ffmpeg:BuildRequires: ffmpeg-devel}
%{!?_without_x10:BuildRequires: perl(X10::ActiveHome) perl(Astro::SunTime)}

Requires:   httpd php php-mysql cambozola polkit
Requires:   libjpeg-turbo libcurl vlc-core ffmpeg
Requires:   perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))
Requires:   perl(DBD::mysql) perl(Archive::Tar) perl(Archive::Zip)
Requires:   perl(MIME::Entity) perl(MIME::Lite) perl(Net::SMTP) perl(Net::FTP)
Requires:   perl(LWP::Protocol::https)

Requires(post): systemd-units systemd-sysv
Requires(post): /usr/bin/gpasswd
Requires(post): /usr/bin/less
Requires(preun): systemd-units
Requires(postun): systemd-units

%description
ZoneMinder is a set of applications which is intended to provide a complete
solution allowing you to capture, analyse, record and monitor any cameras you
have attached to a Linux based machine. It is designed to run on kernels which
support the Video For Linux (V4L) interface and has been tested with cameras
attached to BTTV cards, various USB cameras and IP network cameras. It is
designed to support as many cameras as you can attach to your computer without
too much degradation of performance.

%prep
%setup -q -n ZoneMinder-%{version}

# Unpack jscalendar and move some files around
%setup -q -D -T -a 2 -n ZoneMinder-%{version}
mkdir jscalendar-doc
pushd jscalendar-1.0
mv *html *php doc/* README ../jscalendar-doc
rmdir doc
popd

%patch1 -p0 -b .runlevel
%patch2 -p0 -b .defaults
%{?_without_ffmpeg:%patch3 -p0 -b .noffmpeg}

chmod -x src/zm_event.cpp src/zm_user.h

%build
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf

OPTS=""

%configure \
    --disable-crashtrace \
    --with-libarch=%{_lib} \
    --with-mysql=%{_prefix} \
    --with-ffmpeg=%{_prefix} \
    --with-webdir=%{_datadir}/%{name}/www \
    --with-cgidir=%{_libexecdir}/%{name}/cgi-bin \
    --with-webuser=%{zmuid} \
    --with-webgroup=%{zmgid} \
    --enable-mmap=yes \
    --disable-debug \
    --with-webhost=zm.local \
    ZM_SSL_LIB="gnutls" \
    ZM_RUNDIR=/var/run/zoneminder \
    ZM_TMPDIR=/var/lib/zoneminder/temp \
%ifarch x86_64
    CXXFLAGS="-D__STDC_CONSTANT_MACROS -msse2" \
%else
    CXXFLAGS="-D__STDC_CONSTANT_MACROS" \
%endif
    --with-extralibs="" \
    $OPTS

make %{?_smp_mflags}
%{__perl} -pi -e 's/(ZM_WEB_USER=).*$/${1}%{zmuid_final}/;' \
          -e 's/(ZM_WEB_GROUP=).*$/${1}%{zmgid_final}/;' zm.conf

%install
install -d %{buildroot}/%{_localstatedir}/run
make install DESTDIR=%{buildroot} \
    INSTALLDIRS=vendor
rm -rf %{buildroot}/%{perl_vendorarch} %{buildroot}/%{perl_archlib}
%{?_without_x10:%{__rm} -f %{buildroot}/%{_bindir}/zmx10.pl}

install -m 755 -d %{buildroot}/var/log/zoneminder
for dir in events images temp
do
    install -m 755 -d %{buildroot}/var/lib/zoneminder/$dir
    if [ -d %{buildroot}/%{_datadir}/zoneminder/www/$dir ]; then
	    rmdir %{buildroot}/%{_datadir}/zoneminder/www/$dir
    fi
    ln -sf ../../../../var/lib/zoneminder/$dir %{buildroot}/%{_datadir}/zoneminder/www/$dir
done
install -m 755 -d %{buildroot}/var/lib/zoneminder/sock
install -m 755 -d %{buildroot}/var/lib/zoneminder/swap
install -m 755 -d %{buildroot}/var/spool/zoneminder-upload

install -D -m 644 distros/fedora/zoneminder.conf %{buildroot}/etc/httpd/conf.d/zoneminder.conf
install -D -m 755 distros/fedora/redalert.wav %{buildroot}/%{_datadir}/zoneminder/www/sounds/redalert.wav
install -D -m 644 distros/fedora/zoneminder.service %{buildroot}/%{_unitdir}/zoneminder.service
install -D -m 644 distros/fedora/zoneminder.logrotate %{buildroot}/etc/logrotate.d/zoneminder

# Install jscalendar - this really should be in its own package
install -d -m 755 %{buildroot}/%{_datadir}/%{name}/www/jscalendar
cp -rp jscalendar-1.0/* %{buildroot}/%{_datadir}/zoneminder/www/jscalendar

# Set up cambozola
pushd %{buildroot}/%{_datadir}/zoneminder/www
%{__ln_s} ../../java/cambozola.jar
popd

# Set up mootools
pushd %{buildroot}/%{_datadir}/%{name}/www
ln -f -s tools/mootools/mootools-core-%{moorev}-yc.js mootools-core.js
ln -f -s tools/mootools/mootools-more-%{moorev}.1-yc.js mootools-more.js
popd

# Create an entry for tmpfiles.d
install -D -m 755 distros/fedora/zoneminder.tmpfiles %{buildroot}/etc/tmpfiles.d/zoneminder.conf

install -m 755 -d %{buildroot}/run/zoneminder


%post
if [ $1 -eq 1 ] ; then
    # Initial installation 
    /bin/systemctl daemon-reload >/dev/null 2>&1 || :
fi

# Allow zoneminder access to local video sources, serial ports, and x10
/usr/bin/gpasswd -a %{zmuid_final} video
/usr/bin/gpasswd -a %{zmuid_final} dialout

# Display the README for post installation instructions
/usr/bin/less %{_docdir}/%{name}-%{version}/README.Fedora

%preun
if [ $1 -eq 0 ] ; then
    # Package removal, not upgrade
    /bin/systemctl --no-reload disable zoneminder.service > /dev/null 2>&1 || :
    /bin/systemctl stop zoneminder.service > /dev/null 2>&1 || :
fi

%postun
/bin/systemctl daemon-reload >/dev/null 2>&1 || :
if [ $1 -ge 1 ] ; then
    # Package upgrade, not uninstall
    /bin/systemctl try-restart zoneminder.service >/dev/null 2>&1 || :
fi

%triggerun -- zoneminder < 1.25.0-4
# Save the current service runlevel info
# User must manually run systemd-sysv-convert --apply zoneminder
# to migrate them to systemd targets
/usr/bin/systemd-sysv-convert --save zoneminder >/dev/null 2>&1 ||:

# Run these because the SysV package being removed won't do them
/sbin/chkconfig --del zoneminder >/dev/null 2>&1 || :
/bin/systemctl try-restart zoneminder.service >/dev/null 2>&1 || :


%files
%defattr(-,root,root,-)
%doc AUTHORS COPYING README.md distros/fedora/README.Fedora jscalendar-doc
%config %attr(640,root,%{zmgid_final}) /etc/zm.conf
%config(noreplace) %attr(644,root,root) /etc/httpd/conf.d/zoneminder.conf
%config(noreplace) /etc/tmpfiles.d/zoneminder.conf
%config(noreplace) /etc/logrotate.d/zoneminder

%{_unitdir}/zoneminder.service

%{_bindir}/zma
%{_bindir}/zmaudit.pl
%{_bindir}/zmc
%{_bindir}/zmcontrol.pl
%{_bindir}/zmdc.pl
%{_bindir}/zmf
%{_bindir}/zmfilter.pl
# zmfix removed from zoneminder 1.26.6
#%attr(4755,root,root) %{_bindir}/zmfix
%{_bindir}/zmpkg.pl
%{_bindir}/zmtrack.pl
%{_bindir}/zmtrigger.pl
%{_bindir}/zmu
%{_bindir}/zmupdate.pl
%{_bindir}/zmvideo.pl
%{_bindir}/zmwatch.pl
%{_bindir}/zmcamtool.pl
%{_bindir}/zmsystemctl.pl
%{!?_without_x10:%{_bindir}/zmx10.pl}
%{_bindir}/zmonvif-probe.pl

%{perl_vendorlib}/ZoneMinder*
%{perl_vendorlib}/ONVIF*
%{perl_vendorlib}/WSDiscovery*
%{perl_vendorlib}/WSSecurity*
%{_mandir}/man*/*
%dir %{_libexecdir}/zoneminder
%{_libexecdir}/zoneminder/cgi-bin
%dir %{_datadir}/zoneminder
%{_datadir}/zoneminder/db
%{_datadir}/zoneminder/www

%{_datadir}/polkit-1/actions/com.zoneminder.systemctl.policy
%{_datadir}/polkit-1/rules.d/com.zoneminder.systemctl.rules

%dir %attr(755,%{zmuid_final},%{zmgid_final}) /var/lib/zoneminder
%dir %attr(755,%{zmuid_final},%{zmgid_final}) /var/lib/zoneminder/events
%dir %attr(755,%{zmuid_final},%{zmgid_final}) /var/lib/zoneminder/images
%dir %attr(755,%{zmuid_final},%{zmgid_final}) /var/lib/zoneminder/sock
%dir %attr(755,%{zmuid_final},%{zmgid_final}) /var/lib/zoneminder/swap
%dir %attr(755,%{zmuid_final},%{zmgid_final}) /var/lib/zoneminder/temp
%dir %attr(755,%{zmuid_final},%{zmgid_final}) /var/log/zoneminder
%dir %attr(755,%{zmuid_final},%{zmgid_final}) /var/spool/zoneminder-upload
%dir %attr(755,%{zmuid_final},%{zmgid_final}) /run/zoneminder


%changelog
* Sat Feb 01 2014 Andrew Bauer <knnniggett@users.sourceforge.net> - 1.27
- Add zmcamtool.pl. Bump version for 1.27 release. 

* Mon Dec 16 2013 Andrew Bauer <knnniggett@users.sourceforge.net> - 1.26.5
- This is a bug fixe release
- RTSP fixes, cmake enhancements, couple other misc fixes

* Sat Oct 05 2013 Andrew Bauer <knnniggett@users.sourceforge.net> - 1.26.4
- Fedora specific path changes have been moved to zoneminder-1.26.0-defaults.patch
- All files are now part of the zoneminder source tree. Update specfile accordingly.

* Sat Sep 21 2013 Andrew Bauer <knnniggett@users.sourceforge.net> - 1.26.3
- Initial rebuild for ZoneMinder 1.26.3 release.

* Fri Feb 15 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.25.0-13
- Rebuilt for https://fedoraproject.org/wiki/Fedora_19_Mass_Rebuild

* Mon Jan 21 2013 Adam Tkac <atkac redhat com> - 1.25.0-12
- rebuild due to "jpeg8-ABI" feature drop

* Mon Jan  7 2013 Remi Collet <rcollet@redhat.com> - 1.25.0-11
- fix configuration file for httpd 2.4, #871502

* Fri Dec 21 2012 Adam Tkac <atkac redhat com> - 1.25.0-10
- rebuild against new libjpeg

* Thu Aug 09 2012 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.25.0-9
- Add patch to work around v4l2 api breakage in 3.5 kernel.

* Sun Jul 22 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.25.0-8
- Rebuilt for https://fedoraproject.org/wiki/Fedora_18_Mass_Rebuild

* Sat Jun 23 2012 Petr Pisar <ppisar@redhat.com> - 1.25.0-7
- Perl 5.16 rebuild

* Wed Mar 21 2012 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.25.0-6
- Fix stupid thinko in sql modifications.

* Sat Feb 25 2012 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.25.0-5
- Clean up macro usage.

* Sat Feb 25 2012 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.25.0-4
- Convert to systemd.
- Add tmpfiles.d configuration since the initscript isn't around to create
  /run/zoneminder.
- Remove some pointless executable permissions.
- Add logrotate file.

* Wed Feb 22 2012 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.25.0-3
- Update README.Fedora to reference systemctl and mention timezone info in
  php.ini.
- Add proper default for EYEZM_LOG_TO_FILE.


* Thu Feb 09 2012 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.25.0-2
- Rebuild for new pcre.

* Thu Jan 19 2012 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.25.0-1
- Update to 1.25.0
- Fix gcc4.7 build problems.
- Drop gcc4.4 build fixes; for whatever reason they now break the build.
- Clean up old patches.
- Force setting of ZM_TMPDIR and ZM_RUNDIR.

* Sat Jan 14 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.24.4-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_17_Mass_Rebuild

* Thu Sep 15 2011 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.4-3
- Re-add the dist-tag that somehow got lost.

* Thu Sep 15 2011 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.4-2
- Add patch for bug 711780 - fix syntax issue in Mapped.pm.
- Undo that patch, and undo another which was the cause of the whole mess.
- Fix up other patches so ZM_PATH_BUILD is both defined and useful.
- Make sure database creation mods actually take.
- Update Fedora-specific docs with some additional info.
- Use bundled mootools (javascript, so no guideline violation).
- Update download location.
- Update the gcrypt patch to actually work.
- Upstream changed the tarball without changing the version to patch a
  vulnerability, so redownload.

* Sun Aug 14 2011 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.4-1
- Initial attempt to upgrade to 1.24.4.
- Add patch from BZ 460310 to build against libgcrypt instead of requiring the
  gnutls openssl libs.

* Thu Jul 21 2011 Petr Sabata <contyk@redhat.com> - 1.24.3-7.20110324svn3310
- Perl mass rebuild

* Wed Jul 20 2011 Petr Sabata <contyk@redhat.com> - 1.24.3-6.20110324svn3310
- Perl mass rebuild

* Mon May 09 2011 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.3-5.20110324svn3310
- Bump for gnutls update.

* Thu Mar 24 2011 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.3-4.20110324svn3310
- Update to latest 1.24.3 subversion.  Turns out that what upstream was calling
  1.24.3 is really just an occasionally updated devel snapshot.
- Rebase various patches.

* Wed Mar 23 2011 Dan Horák <dan@danny.cz> - 1.24.3-3
- rebuilt for mysql 5.5.10 (soname bump in libmysqlclient)

* Tue Feb 08 2011 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.24.3-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_15_Mass_Rebuild

* Tue Jan 25 2011 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.3-1
- Update to latest upstream version.
- Rebase patches.
- Initial incomplete attempt to disable v4l1 support.

* Fri Jan 21 2011 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.2-6
- Unbundle cambozola; instead link to the separately pacakged copy.
- Remove BuildRoot:, %%clean and buildroot cleaning in %%install.
- Git rid of mixed space/tab usage by removing all tabs.
- Remove unnecessary Conflicts: line.
- Attempt to force short_open_tag on for the code directories.
- Move default location of sockets, swaps, logfiles and some temporary files to
  make more sense and allow things to work better with a future selinux policy.
- Fix errors in README.Fedora.

* Wed Jun 02 2010 Marcela Maslanova <mmaslano@redhat.com> - 1.24.2-5
- Mass rebuild with perl-5.12.0

* Fri Dec  4 2009 Stepan Kasal <skasal@redhat.com> - 1.24.2-4
- rebuild against perl 5.10.1
- use Perl vendorarch and archlib variables correctly

* Mon Jul 27 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.24.2-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_12_Mass_Rebuild

* Wed Jul 22 2009 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.2-2
- Bump release since 1.24.2-1 was mistakenly tagged a few months ago.

* Wed Jul 22 2009 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.24.2-1
- Initial update to 1.24.2.
- Rebase patches.
- Update mootools download location.
- Update to mootools 1.2.3.
- Add additional dependencies for some optional features.

* Sat Apr 11 2009 Martin Ebourne <martin@zepler.org> - 1.24.1-3
- Remove unused Sys::Mmap perl dependency RPM is finding

* Sat Apr 11 2009 Martin Ebourne <martin@zepler.org> - 1.24.1-2
- Update gcc44 patch to disable -frepo, seems to be broken with gcc44
- Added noffmpeg patch to make building outside mock easier

* Sat Mar 21 2009 Martin Ebourne <martin@zepler.org> - 1.24.1-1
- Patch for gcc 4.4 compilation errors
- Upgrade to 1.24.1

* Wed Feb 25 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.23.3-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_11_Mass_Rebuild

* Sat Jan 24 2009 Caolán McNamara <caolanm@redhat.com> - 1.23.3-3
- rebuild for dependencies

* Mon Dec 15 2008 Martin Ebourne <martin@zepler.org> - 1.23.3-2
- Fix permissions on zm.conf

* Fri Jul 11 2008 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.23.3-1
- Initial attempt at packaging 1.23.

* Tue Jul  1 2008 Martin Ebourne <martin@zepler.org> - 1.22.3-15
- Add perl module compat dependency, bz #453590

* Tue May  6 2008 Martin Ebourne <martin@zepler.org> - 1.22.3-14
- Remove default runlevel, bz #441315

* Mon Apr 28 2008 Jason L Tibbitts III <tibbs@math.uh.edu> - 1.22.3-13
- Backport patch for CVE-2008-1381 from 1.23.3 to 1.22.3.

* Tue Feb 19 2008 Fedora Release Engineering <rel-eng@fedoraproject.org> - 1.22.3-12
- Autorebuild for GCC 4.3

* Thu Jan  3 2008 Martin Ebourne <martin@zepler.org> - 1.22.3-11
- Fix compilation on gcc 4.3

* Thu Dec  6 2007 Martin Ebourne <martin@zepler.org> - 1.22.3-10
- Rebuild for new openssl

* Thu Aug  2 2007 Martin Ebourne <martin@zepler.org> - 1.22.3-8
- Fix licence tag

* Thu Jul 12 2007 Martin Ebourne <martin@zepler.org> - 1.22.3-7
- Fixes from testing by Jitz including missing dependencies and database creation

* Sat Jun 30 2007 Martin Ebourne <martin@zepler.org> - 1.22.3-6
- Disable crashtrace on ppc

* Sat Jun 30 2007 Martin Ebourne <martin@zepler.org> - 1.22.3-5
- Fix uid for directories in /var/lib/zoneminder

* Tue Jun 26 2007 Martin Ebourne <martin@zepler.org> - 1.22.3-4
- Added perl Archive::Tar dependency
- Disabled web interface due to lack of access control on the event images

* Sun Jun 10 2007 Martin Ebourne <martin@zepler.org> - 1.22.3-3
- Changes recommended in review by Jason Tibbitts

* Mon Apr  2 2007 Martin Ebourne <martin@zepler.org> - 1.22.3-2
- Standardised on package name of zoneminder

* Thu Dec 28 2006 Martin Ebourne <martin@zepler.org> - 1.22.3-1
- First version. Uses some parts from zm-1.20.1 by Corey DeLasaux and Serg Oskin
