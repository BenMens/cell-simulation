class ViewBase {
    private ViewBase parentView = null;
    private ArrayList<ViewBase> childViews = new ArrayList<ViewBase>();

    PVector position = new PVector();
    float scale = 1;

    // PVector translationRelativeToParentView = new PVector();
    // PVector scalingRelativeToParentView = new PVector();
    // PVector position = new PVector();

    boolean isVisible = true;


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
        pushMatrix();

        translate(position.x, position.y);
        scale(scale);
        if(isVisible) {
            beforeDrawChildren();

            for (ViewBase childView: childViews) {
                childView.draw();
            }

            afterDrawChildren();
        }

        popMatrix();
    }

    void beforeDrawChildren() {}
    void afterDrawChildren() {}


    final boolean mousePressed() {
        if (beforeMousePressedChildren()) {
            return true;
        }

        boolean mousePressedHandled = false;
        for (ViewBase childView: childViews) {
            if(childView.mousePressed()) {
                mousePressedHandled = true;
            }
        }
        if(mousePressedHandled) {
            return true;
        }

        if(afterMousePressedChildren()) {
            return true;
        }

        return false;
    }

    boolean beforeMousePressedChildren() {
        return false;
    }
    boolean afterMousePressedChildren() {
        return false;
    }
}
