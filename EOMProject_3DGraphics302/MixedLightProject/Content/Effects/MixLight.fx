#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

#define PL_AMOUNT 2

//Matrices
matrix World;
matrix View;
matrix Projection;

Texture2D shaderTexture;

//Point Light
float4 DiffuseColors[PL_AMOUNT];
float3 LightPositions[PL_AMOUNT];

SamplerState SampleType
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct VertexShaderInput
{
	float4 Position : POSITION0;
    float2 Tex : TEXCOORD0;
	float3 Normal : NORMAL;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
    float2 Tex : TEXCOORD0;
    float3 Normal : NORMAL;
    float3 LightPos1 : TEXCOORD1;
    float3 LightPos2 : TEXCOORD2;

};

VertexShaderOutput MainVS(in VertexShaderInput input)
{
	VertexShaderOutput output;
    float4 worldPosition;

    input.Position.w = 1f;
	
    output.Position = mul(input.Position, World);
    output.Position = mul(output.Position, View);
    output.Position = mul(output.Position, Projection);
	
    output.Tex = input.Tex;
	
    output.Normal = mul(input.Normal, (float3x3) World);
	
    output.Normal = normalize(output.Normal);
	
    worldPosition = mul(input.Position, World);
	
    output.LightPos1 = LightPositions[0].xyz - worldPosition.xyz;
    output.LightPos2 = LightPositions[1].xyz - worldPosition.xyz;
	
    output.LightPos1 = normalize(output.LightPos1);
    output.LightPos2 = normalize(output.LightPos2);
	
	return output;
}

float4 MainPS(VertexShaderOutput input) : COLOR
{
    float4 textureColor;
    float lightIntensity1, lightIntensity2;
    float4 color, color1, color2;
	
    lightIntensity1 = saturate(dot(input.Normal, input.LightPos1));
    lightIntensity2 = saturate(dot(input.Normal, input.LightPos2));
	
    color1 = DiffuseColors[0] * lightIntensity1;
    color2 = DiffuseColors[1] * lightIntensity2;
	
    textureColor = shaderTexture.Sample(SampleType, input.Tex);
	
    color = saturate(color1 + color2) * textureColor;
	
    return color;
}

technique BasicColorDrawing
{
	pass P0
	{
		VertexShader = compile VS_SHADERMODEL MainVS();
		PixelShader = compile PS_SHADERMODEL MainPS();
	}
};