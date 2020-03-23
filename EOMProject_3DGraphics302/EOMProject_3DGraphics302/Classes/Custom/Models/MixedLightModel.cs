using EOMProject_3DGraphics302.Classes.Custom.Materials;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Sample;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EOMProject_3DGraphics302.Classes.Custom.Models
{
    public class MixedLightModel : CustomEffectModel
    {
        public MixedLightModel(string assetName, Vector3 position) : base(assetName, position)
        {
            Material = new MixedLightMaterial()
            {
                PointLightPositions = new Vector3[] { new Vector3(1, 1, 1), new Vector3(-1, 1, -1) },
                PointLightAttenuations = new float[] { 100, 100 },
                PointLightColors = new Color[] { Color.Red, Color.Blue },
                PointLightFallOff = 2,

                DirectionalLightColor = Color.White,
                DirectionalLightDirection = new Vector3(0, 1, 0),

                AmbientColor = Color.White,
                DiffuseColor = Color.White,

                DiffuseTextureOne = GameUtilities.Content.Load<Texture2D>("Textures/wood4"),
                ////NormalTexture = GameUtilities.Content.Load<Texture2D>(@"Textures/WoodNormal"),
                SpecularColor = Color.White,
                SpecularPower = 0.3f,

            };

            CustomEffect = GameUtilities.Content.Load<Effect>("Effects/MixedLightEffect");
        }

        public override void LoadContent()
        {
            base.LoadContent();
        }

    }
}
