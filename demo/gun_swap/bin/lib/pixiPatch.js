/**
 * Série de patchs Pixi en attendant le Fix officiel
 * @author Mathieu Anthoine
 */

// version 3.0.11 de Pixi
PIXI.Container.prototype.getLocalBounds = function ()
{
	
	var matrixCache = this.worldTransform;

    this.worldTransform = PIXI.Matrix.IDENTITY;

    for (var i = 0, j = this.children.length; i < j; ++i) this.children[i].updateTransform();

    this.worldTransform = matrixCache;

    this._currentBounds = null;

	var lBounds=this.getBounds( PIXI.Matrix.IDENTITY );
	
	this._currentBounds = null;

    return lBounds;
};