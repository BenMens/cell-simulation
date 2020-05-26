import java.awt.geom.Rectangle2D;


class GuiController  implements BodyModelClient {
    ViewBase parentView;
    BodyModel bodyModel;
    BodyController bodyController;
    ZoomView bodyContainerView;
    CellController selectedCellController;


    GuiController(ViewBase parentView, BodyModel bodyModel) {
        this.parentView = parentView;

        bodyContainerView = new ZoomView(parentView);
        bodyContainerView.frameRect = new Rectangle2D.Float(20, 20, 700, 700);
        bodyContainerView.boundsRect = new Rectangle2D.Float(0, 0, 700, 700);
        bodyContainerView.hasClip = true;

        bodyController = new BodyController(bodyContainerView, bodyModel);

        bodyContainerView.setZoomView(bodyController.bodyView);

        bodyModel.registerClient(this);
    }

    void onSelectCell(CellModel selectedCell) {
        if (this.selectedCellController != null) {
            this.selectedCellController.destroy(); 
            this.selectedCellController = null;
        }

        if (selectedCell != null) {
            this.selectedCellController = new CellController(parentView, selectedCell);

            this.selectedCellController.cellView.frameRect = new Rectangle2D.Float(750, 20, 200, 200);
        }
    }


    void onAddCell(CellModel cellModel) {}

    void onAddParticle(ParticleBaseModel particleModel) {}
}
