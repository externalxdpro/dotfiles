#!/usr/bin/env bash

keybind="$1"
direction="$2"
monitor=$(mmsg get focusing-client | jq -r ".monitor")
layout=$(mmsg get monitor "$monitor" | jq -r ".layout_symbol")
# S=Scroller,T=Tile,G=Grid,M=Monocle,K=Deck,CT=Center Tile,
# RT=Right Tile,VS=Vertical Scroller,VT=Vertical Tile,
# VG=Vertical Grid,VK=Vertical Deck,TG=TGMix

disp() {
	mmsg dispatch "$1","$2"
}

case $layout in
    S)
	case $keybind in
	    focus)
		if [[ $direction == j ]]; then
		    disp focusstack prev
		elif [[ $direction == k ]]; then
		    disp focusstack next
		fi
		;;
	    move)
		if [[ $direction == j ]]; then
		    disp exchange_stack_client prev
		elif [[ $direction == k ]]; then
		    disp exchange_stack_client next
		fi
		;;
	    resize)
		disp switch_proportion_preset
	esac
	;;
    *)
	case $keybind in
	    focus)
		if [[ $direction == j ]]; then
		    disp focusstack next
		elif [[ $direction == k ]]; then
		    disp focusstack prev
		fi
		;;
	    move)
		if [[ $direction == j ]]; then
		    disp exchange_stack_client next
		elif [[ $direction == k ]]; then
		    disp exchange_stack_client prev
		fi
		;;
	    resize)
		if [[ $direction == h ]]; then
		    disp resizewin -10,0
		elif [[ $direction == l ]]; then
		    disp resizewin +10,0
		fi
		;;
	esac
	;;
esac
