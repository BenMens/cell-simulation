import java.awt.geom.Rectangle2D;


class GuiController  implements BodyModelClient {
    ViewBase parentView;
    BodyModel bodyModel;
    BodyController bodyController;
    ZoomView bodyContainerView;
    CellController selectedCellController;
    CellEditorController cellEditorController;


    GuiController(ViewBase parentView, BodyModel bodyModel) {
        this.parentView = parentView;

        bodyContainerView = new ZoomView(parentView);
        bodyContainerView.frameRect = new Rectangle2D.Float(20, 20, height - 40, height - 40);
        bodyContainerView.boundsRect = new Rectangle2D.Float(0, 0, height - 40, height - 40);
        bodyContainerView.shouldClip = true;

        bodyController = new BodyController(bodyContainerView, bodyModel);

        bodyContainerView.setZoomView(bodyController.bodyView);

        bodyModel.registerClient(this);

    }

    void onSelectCell(CellModel selectedCell) {
        if (this.selectedCellController != null) {
            this.selectedCellController = null;
            this.cellEditorController = null;
        }

        if (selectedCell != null) {
            this.selectedCellController = new CellController(parentView, selectedCell);
            this.selectedCellController.cellView.frameRect = new Rectangle2D.Float(height, 20, 200, 200);
            
            this.cellEditorController = new CellEditorController(parentView, selectedCell, new Rectangle2D.Float(height, 240, width - height - 20, height - 260));
        }
    }


    void onAddCell(CellModel cellModel) {}

    void onAddParticle(ParticleBaseModel particleModel) {}
}
