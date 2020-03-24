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
                PointLightPositions = new Vector3[] { new Vector3(0, 10, 10), new Vector3(100, 100, 100) },
                PointLightAttenuations = new float[] { 100, 100 },
                PointLightColors = new Color[] { Color.White, Color.White },
                DiffuseTextureOne = GameUtilities.Content.Load<Texture2D>("Textures/wood4"),
                NormalTexture = GameUtilities.Content.Load<Texture2D>(@"Textures/WoodNormal"),


            };

            CustomEffect = GameUtilities.Content.Load<Effect>("Effects/MixedLightEffect");
        }

        public override void LoadContent()
        {
            base.LoadContent();
        }

    }
}
