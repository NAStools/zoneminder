//
// ZoneMinder base static javascript file, $Date$, $Revision$
// Copyright (C) 2001-2008 Philip Coombes
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//

//
// This file should only contain static JavaScript and no php.
// Use skin.js.php for JavaScript that need pre-processing
//

// Javascript window sizes
var popupSizes = {
    'bandwidth':    { 'width': 300, 'height': 120 },
    'console':      { 'width': 750, 'height': 312 },
    'control':      { 'width': 380, 'height': 480 },
    'controlcaps':  { 'width': 780, 'height': 320 },
    'controlcap':   { 'width': 400, 'height': 400 },
    'cycle':        { 'addWidth': 32, 'minWidth': 384, 'addHeight': 62 },
    'device':       { 'width': 260, 'height': 150 },
    'devices':      { 'width': 400, 'height': 240 },
    'donate':       { 'width': 500, 'height': 280 },
    'event':        { 'addWidth': 108, 'minWidth': 496, 'addHeight': 230, minHeight: 540 },
    'eventdetail':  { 'width': 600, 'height': 220 },
    'events':       { 'width': 960, 'height': 780 },
    'export':       { 'width': 400, 'height': 340 },
    'filter':       { 'width': 720, 'height': 360 },
    'filtersave':   { 'width': 610, 'height': 120 },
    'frame':        { 'addWidth': 32, 'minWidth': 384, 'addHeight': 100 },
    'frames':       { 'width': 500, 'height': 600 },
    'function':     { 'width': 300, 'height': 92 },
    'group':        { 'width': 360, 'height': 180 },
    'groups':       { 'width': 440, 'height': 220 },
    'image':        { 'addWidth': 48, 'addHeight': 80 },
    'log':          { 'width': 1080, 'height': 720 },
    'login':        { 'width': 720, 'height': 480 },
    'logout':       { 'width': 260, 'height': 100 },
    'monitor':      { 'width': 450, 'height': 440 },
    'monitorpreset':{ 'width': 440, 'height': 200 },
    'monitorprobe': { 'width': 500, 'height': 240 },
    'monitorselect':{ 'width': 160, 'height': 200 },
    'montage':      { 'width': -1, 'height': -1 },
    'onvifprobe':   { 'width': 500, 'height': 300 },
    'optionhelp':   { 'width': 400, 'height': 320 },
    'options':      { 'width': 1000, 'height': 660 },
    'preset':       { 'width': 300, 'height': 120 },
    'settings':     { 'width': 220, 'height': 225 },
    'state':        { 'width': 370, 'height': 134 },
    'stats':        { 'width': 840, 'height': 200 },
    'timeline':     { 'width': 760, 'height': 540 },
    'user':         { 'width': 360, 'height': 420 },
    'version':      { 'width': 360, 'height': 140 },
    'video':        { 'width': 420, 'height': 360 },
    'videoview':    { 'addWidth': 48, 'addHeight': 80 },
    'watch':        { 'addWidth': 96, 'minWidth': 420, 'addHeight': 384 },
    'zone':         { 'addWidth': 450, 'addHeight': 200, 'minHeight': 450 },
    'zones':        { 'addWidth': 72, 'addHeight': 232 }
};
