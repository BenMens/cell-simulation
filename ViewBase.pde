class ViewBase {
    private ViewBase parentView = null;
    private ArrayList<ViewBase> childViews = new ArrayList<ViewBase>();


    final ViewBase getParentView() {
        return parentView;
    }


    final void setParentView(ViewBase newParentView) {
        ViewBase oldParentView = parentView;

        if(oldParentView != null) {
            oldParentView.removeChildView(this);
        }

        parentView = newParentView;
    }


    final ArrayList<ViewBase> getChildViews() {
        return childViews;
    }


    final void addChildView(ViewBase childView) {
        if(!childViews.contains(childView)) {
            childView.setParentView(this);
            childViews.add(childView);
        }
    }


    final void removeChildView(ViewBase childView) {
        childView.setParentView(null);
        childViews.remove(childView);
    }


    final void draw() {
        beforeDrawChildren();

        for (ViewBase childView: childViews) {
            childView.draw();
        }

        afterDrawChildren();
    }
    void beforeDrawChildren() {}
    void afterDrawChildren() {}
}
