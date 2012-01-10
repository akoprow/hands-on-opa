##extern-type dom_element

##register mk_resizable: dom_element -> void
##args(dom)
{
    dom.resizable({animate: true});
}
