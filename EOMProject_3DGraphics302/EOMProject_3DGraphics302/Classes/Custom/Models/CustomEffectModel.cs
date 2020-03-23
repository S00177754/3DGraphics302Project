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
    public class CustomEffectModel : SimpleModel
    {
        /// <summary> Effect to be used by this model. </summary>
        public Effect CustomEffect;

        //Stores params to be used by the effect
        public Material Material;

        public CustomEffectModel(string assetName, Vector3 position) : base("", assetName, position)
        {

        }

        public override void LoadContent()
        {
            base.LoadContent(); //Loading in 3D Model.

            //Replace effect thats applied to model by default.
            //Replace with any custom effect.

            if (Model != null)
            {
                GenerateMeshTag();

                if (CustomEffect != null)
                {

                    foreach (ModelMesh model in Model.Meshes)
                    {
                        foreach (ModelMeshPart part in model.MeshParts)
                        {
                            part.Effect = CustomEffect;
                        }
                    }
                }
            }
        }

        public override void Update()
        {
            if (Material != null)
                Material.Update();

            base.Update();
        }

        public override void Draw(Camera camera)
        {
            if (CustomEffect != null)
            {
                SetModelEffect(CustomEffect, true);

                foreach (ModelMesh mesh in Model.Meshes)
                {
                    foreach (ModelMeshPart part in mesh.MeshParts)
                    {
                        //The original effect will have been swapped out before we get here
                        //game1.draw handles depth and normal

                        SetEffectParameter(part.Effect, "World", BoneTransforms[mesh.ParentBone.Index] * World);
                        SetEffectParameter(part.Effect, "View", camera.View);
                        SetEffectParameter(part.Effect, "Projection", camera.Projection);

                        if (Material != null)
                            Material.SetEffectParameters(part.Effect);
                    }

                    mesh.Draw();
                }
            }
            else
            {
                base.Draw(camera);
            }

        }

        public void GenerateMeshTag()
        {
            foreach (ModelMesh mesh in Model.Meshes)
            {
                foreach (ModelMeshPart part in mesh.MeshParts)
                {
                    MeshTag tag = new MeshTag();

                    if (part.Effect is BasicEffect)
                    {
                        tag.Color = (part.Effect as BasicEffect).DiffuseColor;
                        tag.Texture = (part.Effect as BasicEffect).Texture;
                        tag.SpecularPower = (part.Effect as BasicEffect).SpecularPower;

                        part.Tag = tag;
                    }
                }
            }
        }

        public virtual void CacheEffect()
        {
            foreach (ModelMesh mesh in Model.Meshes)
                foreach (ModelMeshPart part in mesh.MeshParts)
                {
                    (part.Tag as MeshTag).CachedEffect = part.Effect;
                }
        }

        public virtual void RestoreEffect()
        {
            foreach (ModelMesh mesh in Model.Meshes)
                foreach (ModelMeshPart part in mesh.MeshParts)
                {
                    if (part.Tag != null)
                    {
                        if ((part.Tag as MeshTag).CachedEffect != null)
                        {
                            part.Effect = (part.Tag as MeshTag).CachedEffect;
                        }
                    }
                }
        }

        public virtual void SetEffectParameter(Effect effect, string paramName, object value)
        {
            if (effect.Parameters[paramName] == null)
                return;

            if (value is Vector3)
            {
                effect.Parameters[paramName].SetValue((Vector3)value);
            }
            else if (value is Matrix)
            {
                effect.Parameters[paramName].SetValue((Matrix)value);
            }
            else if (value is bool)
            {
                effect.Parameters[paramName].SetValue((Matrix)value);
            }
            else if (value is Texture2D)
            {
                effect.Parameters[paramName].SetValue((Texture2D)value);
            }
            else if (value is float)
            {
                effect.Parameters[paramName].SetValue((float)value);
            }
            else if (value is int)
            {
                effect.Parameters[paramName].SetValue((int)value);
            }
        }

        public virtual void SetModelEffect(Effect effect, bool copyEffect)
        {
            CacheEffect();

            foreach (ModelMesh mesh in Model.Meshes)
            {
                foreach (ModelMeshPart part in mesh.MeshParts)
                {
                    Effect toBeSet = effect;

                    if (copyEffect)
                    {
                        toBeSet = effect.Clone();
                    }

                    var tag = (part.Tag as MeshTag);

                    if (tag.Texture != null)
                    {
                        SetEffectParameter(toBeSet, "Texture", tag.Texture);
                        SetEffectParameter(toBeSet, "TextureEnabled", true);
                    }
                    else
                    {
                        SetEffectParameter(toBeSet, "TextureEnabled", false);
                    }

                    SetEffectParameter(toBeSet, "DiffuseColor", tag.Color);
                    SetEffectParameter(toBeSet, "SpecularPower", tag.SpecularPower);

                    part.Effect = toBeSet;
                }
            }
        }
    }

}
