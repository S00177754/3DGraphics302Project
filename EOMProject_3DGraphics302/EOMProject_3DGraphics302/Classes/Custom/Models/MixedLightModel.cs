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
                DirectionalLightColor = Color.White,
                DirectionalLightDirection = new Vector3(0,0,1),
                DiffuseTextureOne = GameUtilities.Content.Load<Texture2D>(@"Textures/wood4"),
                NormalTexture = GameUtilities.Content.Load<Texture2D>(@"Textures/WoodNormal")
            };

            CustomEffect = GameUtilities.Content.Load<Effect>("Effects/MixedLightEffect");
        }

        public override void Update()
        {
            base.Update();
        }

        public override void LoadContent()
        {
            base.LoadContent();
        }

        public void UpdateCamera(Vector3 camPos)
        {
            (Material as MixedLightMaterial).UpdateCamera(camPos);
        }

    }
}
