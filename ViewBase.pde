import java.awt.geom.Rectangle2D;


class ViewBase {
    private ViewBase parentView = null;
    private ArrayList<ViewBase> childViews = new ArrayList<ViewBase>();

    Rectangle2D.Float frameRect;  // View dimension in Parent coordinates
    Rectangle2D.Float boundsRect; // View dimension 

    boolean hasClip = false;
    boolean isVisible = true;


    ViewBase(ViewBase parent) {
        if (parent == null) {
            this.frameRect = new Rectangle2D.Float(0, 0, width, height);
            this.boundsRect = new Rectangle2D.Float(0, 0, width, height);
        } else {
            setParentView(parent);
            this.frameRect = new Rectangle2D.Float(0, 0, parent.boundsRect.width, parent.boundsRect.height);
            this.boundsRect = new Rectangle2D.Float(0, 0, parent.boundsRect.width, parent.boundsRect.height);
        }
    }


    final ViewBase getParentView() {
        return parentView;
    }


    final void setParentView(ViewBase newParentView) {
        if (parentView != newParentView) {
            
            if (parentView != null) {
                parentView.childViews.remove(this);
            }

            parentView = newParentView;

            if (parentView != null) {

                if (!parentView.childViews.contains(this)) {
                    parentView.childViews.add(this);
                }
            }
        } 
    }


    final ArrayList<ViewBase> getChildViews() {
        return childViews;
    }


    void makeChildsVisible() {
        for (ViewBase child : childViews) {
            child.isVisible = true;
        }
    }

    void makeChildsInvisible() {
        for (ViewBase child : childViews) {
            child.isVisible = false;
        }
    }


    final void draw() {
        Rectangle2D.Float clipBoundary = getClipBoundary();

        if(clipBoundary == null || (clipBoundary.width > 0 && clipBoundary.height > 0)) {
            pushMatrix();

            if (clipBoundary != null) {
                clip(clipBoundary.x, clipBoundary.y, clipBoundary.width, clipBoundary.height);
            } else {
                noClip();
            }

            translate(frameRect.x, frameRect.y);
            PVector scale = getScale();
            scale(scale.x, scale.y);
            translate(-boundsRect.x, -boundsRect.y);
            
            if (isVisible) {
                beforeDrawChildren();

                for (ViewBase childView: childViews) {
                    childView.draw();
                }

                afterDrawChildren();
            }

            popMatrix();
        }
    }

    void beforeDrawChildren() {}
    void afterDrawChildren() {}


    PVector composedScale() {
        PVector result = getScale();

        if (this.parentView != null) {
            PVector parentScale = this.parentView.composedScale();
            
            result.x *= parentScale.x;
            result.y *= parentScale.y;
        }

        return result;
    }

    PVector screenSizeToViewSize(PVector size) {
        PVector result = size.copy();

        if (parentView != null) {
            result = parentView.screenSizeToViewSize(result);
        }

        PVector scale = getScale();

        result.x /= scale.x;
        result.y /= scale.y;

        return result;
    }


    PVector getScale() {
        return new PVector(
            frameRect.width / boundsRect.width,
            frameRect.height / boundsRect.height
        );
    }


    void setScale(float scale) {
        boundsRect.width = frameRect.width / scale;
        boundsRect.height = frameRect.height / scale;
    }


    void setScale(PVector scale) {
        boundsRect.width = frameRect.width / scale.x;
        boundsRect.height = frameRect.height / scale.y;
    }


    PVector viewSizeToScreenSize(PVector size) {
        PVector result = size.copy();

        PVector scale = getScale();
        result.x *= scale.x;
        result.y *= scale.y;

        if (parentView != null) {
            result = parentView.viewSizeToScreenSize(result);
        }

        return result;
    }


    PVector screenPosToViewPos(PVector pos) {
        PVector result = pos.copy();

        if (parentView != null) {
            result = parentView.screenPosToViewPos(result);
        }

        result.sub(frameRect.x, frameRect.y);
        
        PVector scale = getScale();
        result.x /= scale.x;
        result.y /= scale.y;

        result.add(boundsRect.x, boundsRect.y);

        return result;
    }
    


    PVector viewPosToScreenPos(PVector pos) {
        PVector result = pos.copy();

        result.sub(boundsRect.x, boundsRect.y);
        
        PVector scale = getScale();
        result.x *= scale.x;
        result.y *= scale.y;
        
        result.add(frameRect.x, frameRect.y);

        if (parentView != null) {
            result = parentView.viewPosToScreenPos(result);
        }

        return result;
    }

    
    Rectangle2D.Float getClipBoundary() {
        Rectangle2D.Float viewClip = null;
        Rectangle2D.Float parentViewClip = null;

        if (hasClip) {
            PVector upperLeft = viewPosToScreenPos(new PVector(boundsRect.x, boundsRect.y));
            PVector lowerRight = viewPosToScreenPos(new PVector(boundsRect.width, boundsRect.height));

            viewClip = new Rectangle2D.Float(upperLeft.x, upperLeft.y, lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y);
        }

        if (parentView != null) {
          parentViewClip = parentView.getClipBoundary();
        }

        if (viewClip != null && parentViewClip != null) {
            Rectangle2D intersection =  parentViewClip.createIntersection(viewClip);
            
            return new Rectangle2D.Float((float)intersection.getX(), (float)intersection.getY(), (float)intersection.getWidth(), (float)intersection.getHeight());
        } else if (viewClip != null) {
            return viewClip;
        } else if (parentViewClip != null) {
            return parentViewClip;
        }

        return null;
    }


    final boolean mousePressed(float parentViewMouseX, float parentViewMouseY) {
        float viewMouseX = (parentViewMouseX - frameRect.x) / getScale().x + boundsRect.x;
        float viewMouseY = (parentViewMouseY - frameRect.y) / getScale().y + boundsRect.y;

        if (hasClip == false || boundsRect.contains(viewMouseX, viewMouseY)) {
            if (beforeMousePressedChildren(viewMouseX, viewMouseY)) {
                return true;
            }

            boolean mousePressedHandled = false;
            for (ViewBase childView: childViews) {
                mousePressedHandled = childView.mousePressed(viewMouseX, viewMouseY) | mousePressedHandled;
            }
            if (mousePressedHandled) {
                return true;
            }

            if (afterMousePressedChildren(viewMouseX, viewMouseY)) {
                return true;
            }
        }

        return false;
    }


    boolean beforeMousePressedChildren(float viewMouseX, float viewMouseY) {
        return false;
    }


    boolean afterMousePressedChildren(float viewMouseX, float viewMouseY) {
        return false;
    }

    void destroy() {
      setParentView(null);
    }
}
