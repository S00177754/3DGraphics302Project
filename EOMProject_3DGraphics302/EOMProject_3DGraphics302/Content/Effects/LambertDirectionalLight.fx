#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

//Input data, stored in variables
matrix World;
matrix View;
matrix Projection;

//Lighting Variables
//True color of obj
float3 DiffuseColor = float3(1, 1, 1);

//Estimation of the color if the surface recieves no light
float3 AmbientLight = float3(0.15,0.15,0.15);

//Direction of light
float3 Direction = float3(0, 0, 1);

//What color is the light
float3 Color = float3(1, 0, 0);

struct VertexShaderInput
{
    float4 Position : POSITION0;
    //float4 Position : SV_Position0;
    float2 UV : TEXCOORD0;
    float3 Normal : NORMAL0;
};

texture Texture;
sampler TextureSampler = sampler_state
{
    texture = <TextureSampler>;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
	float2 UV : TEXCOORD0;
	float3 Normal : TEXCOORD1;
};

VertexShaderOutput MainVS(in VertexShaderInput input)
{
    VertexShaderOutput output;

    float4 worldPosition = mul(input.Position, World);
    float4 viewPosition = mul(worldPosition, View);

    output.Position = mul(viewPosition, Projection);
    output.UV = input.UV;
    output.Normal = mul(input.Normal, World);

    return output;
}

float4 MainPS(VertexShaderOutput input) : COLOR
{
    float3 color = DiffuseColor; //Color of obj
    
    float3 lighting = AmbientLight; //Color when no light
    float3 lightDirection = normalize(Direction); //scales to 0-1 range
    float3 normal = normalize(input.Normal); //scales to 0-1 range
    
    //angle between light and surface normal
    float3 intensity = saturate(dot(lightDirection, normal)) * Color;
    
    lighting += intensity;
    
    return float4(saturate(lighting * color), 1);
}

technique BasicColorDrawing
{
    pass P0
    {
        VertexShader = compile VS_SHADERMODEL MainVS();
        PixelShader = compile PS_SHADERMODEL MainPS();
    }
};

technique SpriteDrawing
{
	pass P0
	{
		PixelShader = compile PS_SHADERMODEL MainPS();
	}
};